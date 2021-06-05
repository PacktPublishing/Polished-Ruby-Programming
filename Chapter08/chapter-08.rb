### 8
### Designing for Extensibility

## Using Ruby's extensibility features

class Libry
  class User
    def initialize(id)
      @id = id
      @books = []
    end
    attr_accessor :books
  end

  class Book
    def initialize(name)
      @name = name
    end
    attr_accessor :checked_out_to
  end
end

# --

class Libry
  class User
    def checkout(book)
      book.checked_out_to = self
      @books << book
    end
  end
end

# --

class Libry
  class Book
    def checkin
      checked_out_to.books.delete(self)
      @checked_out_to = nil
    end
  end
end

# --

book = Libry::Book.new('name')

def book.checked_out_to=(user)
  def user.checkout(book)
    nil
  end

  nil
end

# --

user = Libry::User.new(1)
user.checkout(Libry::Book.new('x'))
user.checkout(book)
user.books.length
# => 2

# --

user.checkout(Libry::Book.new('y'))
user.books.length
# => 2

# --

module Cursed
  module Book
    def checked_out_to=(user)
      user.extend(User)
      super
    end
  end

  module User
    def checkout(book)
      nil
    end
  end
end

# --

user = Libry::User.new(3)
user.checkout(Libry::Book.new('x'))

book = Libry::Book.new('name')
book.extend(Cursed::Book)
user.checkout(book)
user.books.length
# => 2

user.checkout(Libry::Book.new('y'))
user.books.length
# => 2

## Designing plugin systems

class Libry
  class Book; end
  class User; end

# --

  module Plugins
    module Core

# --

      module BookMethods
        attr_accessor :checked_out_to

        def initialize(name)
          @name = name
        end

        def checkin
          checked_out_to.books.delete(self)
          @checked_out_to = nil
        end
      end

# --

      module UserMethods
        attr_accessor :books

        def initialize(id)
          @id = id
          @books = []
        end

        def checkout(book)
          book.checked_out_to = self
          @books << book
        end
      end
    end
  end

# --

  def self.plugin(mod)
    if defined?(mod::BookMethods)
      Book.include(mod::BookMethods)
    end
    if defined?(mod::UserMethods)
      User.include(mod::UserMethods)
    end
  end

# --

  plugin(Plugins::Core)
end

# --

book = Libry::Book.new('b')
user = Libry::User.new 1
user.books.size
# => 0

user.checkout(book)
user.books.size
# => 1

book.checkin
user.books.size
# => 0

# --

class Libry
  module Plugins
    module Cursing
      module BookMethods
        def curse!
          @cursed = true
        end

        def checked_out_to=(user)
          user.curse! if @cursed
          super
        end
      end

# --

      module UserMethods
        def curse!
          @cursed = true
        end

        def checkout(book)
          super unless @cursed
        end
      end
    end
  end
end

# --

Libry.plugin(Libry::Plugins::Cursing)

# --

book = Libry::Book.new('a')
cursed_book = Libry::Book.new('b')
cursed_book.curse!
user = Libry::User.new 2

user.checkout(cursed_book)
user.books.size
# => 1

user.checkout(book)
user.books.size
# => 1

# --

Libry.plugin(Libry::Plugins::Cursing)

# --

class Libry
  def self.plugin(mod)
    # same as before

    if defined?(mod::BookClassMethods)
      Book.extend(mod::BookClassMethods)
    end
    if defined?(mod::UserClassMethods)
      User.extend(mod::UserClassMethods)
    end
  end
end

# --

module Libry::Plugins::Tracking
  module TrackingMethods
    attr_reader :tracked

    def new(*)
      obj = super
      (@tracked ||= []) << obj
      obj
    end
  end

  BookClassMethods = TrackingMethods
  UserClassMethods = TrackingMethods
end

# --

Libry.plugin(Libry::Plugins::Tracking)

Libry::Book.new 'a'
Libry::Book.new 'b'
Libry::Book.tracked.size
# => 2

Libry::User.tracked.size
# NoMethodError

# --

class Libry
  def self.plugin(mod)
    # same as before
    mod.after_load if mod.respond_to?(:after_load)
  end
end

# --

module Libry::Plugins::Tracking
  def self.after_load
    [Libry::Book, Libry::User].each do |klass|
      klass.instance_exec{@tracked ||= []}
    end
  end

# --

  module TrackingMethods
    def new(*)
      obj = super
      @tracked << obj
      obj
    end
  end
end

# --

Libry.plugin(Libry::Plugins::Tracking)

Libry::Book.new 'a'
Libry::Book.new 'b'
Libry::Book.tracked.size
# => 2  # or 4

Libry::User.tracked.size
# => 0

# --

module Libry::Plugins::AutoCurse
  module BookMethods
    def initialize(*)
      super
      curse!
    end
  end

  module UserMethods
    def curse!
      super
      books.each(&:curse!)
    end
  end
end

# --

Libry.plugin(Libry::Plugins::AutoCurse)

Libry::Book.new('a')
# NoMethodError: undefined method `curse!'

# --

class Libry
  def self.plugin(mod)
    mod.before_load if mod.respond_to?(:before_load)
    # same as before
  end
end

# --

module Libry::Plugins::AutoCurse
  def self.before_load
    Libry.plugin(Libry::Plugins::Cursing)
  end
end

# --

user = Libry::User.new 1
book = Libry::Book.new 'a'
user.checkout(book)

book = Libry::Book.new 'b'
Libry.plugin(Libry::Plugins::AutoCurse)

user.curse!
user.checkout(book)
user.books.size
# => 1

# --

class Libry
  PLUGINS = {}

  def self.register_plugin(symbol, mod)
    PLUGINS[symbol] = mod
  end
end

# --

module Libry::Plugins::AutoCurse
  Libry.register_plugin(:auto_curse, self)
end

# --

class Libry
  def self.plugin(mod)
    if mod.is_a?(Symbol)
      require "libry/plugins/#{mod}"
      mod = PLUGINS.fetch(mod)
    end
    # same as before
  end
end

# --

Libry.plugin(:auto_curse)

# --

class Libry
  def self.inherited(subclass)
    subclass.const_set(:Book, Class.new(self::Book))
    subclass.const_set(:User, Class.new(self::User))
  end
end

# --

class Libry
  def self.plugin(mod)
    if mod.is_a?(Symbol)
      require "libry/plugins/#{mod}"
      mod = PLUGINS.fetch(mod)
    end

# --

    mod.before_load(self) if mod.respond_to?(:before_load)

# --

    if defined?(mod::BookMethods)
      self::Book.include(mod::BookMethods)
    end
    if defined?(mod::UserMethods)
      self::User.include(mod::UserMethods)
    end

# --

    if defined?(mod::BookClassMethods)
      self::Book.extend(mod::BookClassMethods)
    end
    if defined?(mod::UserClassMethods)
      self::User.extend(mod::UserClassMethods)
    end

# --

    mod.after_load(self) if mod.respond_to?(:after_load)
  end
end

# --

module Libry::Plugins::Tracking
  def self.after_load(libry)
    [libry::Book, libry::User].each do |klass|
      klass.instance_exec{@tracked ||= []}
    end
  end

# --

  module TrackingMethods
    def inherited(subclass)
      subclass.instance_variable_set(:@tracked, [])
    end
  end
end

# --

module Libry::Plugins::AutoCurse
  def self.before_load(libry)
    libry.plugin(:cursing)
  end
end

# --

libry = Class.new(Libry)

user = libry::User.new 1
book = libry::Book.new 'a'
user.checkout(book)

book = libry::Book.new 'b'
libry.plugin(:auto_curse)

user.curse!
user.checkout(book)
user.books.size
# => 1

# --

user = Libry::User.new 1
user.respond_to?(:curse!)
# => false

# --

class Libry
  def self.plugin(mod, ...)
    # plugin loading code

    if mod.respond_to?(:before_load)
      mod.before_load(self, ...)
    end

    # include/extend code

    if mod.respond_to?(:after_load)
      mod.after_load(self, ...)
    end
  end
end

# --

module Libry::Plugins::Tracking
  def self.after_load(libry, &block)
    [libry::Book, libry::User].each do |klass|
      klass.instance_exec do
        @tracked ||= []
        @callback = block
      end
    end
  end

# --

  module TrackingMethods
    def inherited(subclass)
      callback = @callback
      subclass.instance_exec do
        @tracked = []
        @callback = callback
      end
    end

# --

    def new(*)
      obj = super
      @tracked << obj
      @callback&.(obj)
      obj
    end
  end
end

# --

book = Libry::Book.new('Polished Ruby Programming')
Libry.plugin(Libry::Plugins::Tracking) do |obj|
  if obj.is_a?(Libry::User)
    obj.checkout(book)
  end
end

# --

user = Libry::User.new 1
user.books.map do |book|
  book.instance_variable_get(:@name)
end
# => ["Polished Ruby Programming"]

## Understanding globally frozen, locally mutable design

class MyLibry < Libry
  # application setup/plugin loading
  plugin(:tracking)

  Book.freeze
  User.freeze
  freeze
end

# --

user = MyLibry::User.new(1)
user.freeze
user.checkout(MyLibry::Book.new('b'))

# --

class Foo
  autoload :Object, 'foo/object'
end

# --

Foo.class_eval do
  class Object
    def initialize(object)
      @object = object
    end

    def method_missing(meth, ...)
      @object.send(:run, meth, ...)
    end

    def respond_to_missing?(meth)
      true
    end
  end
end

# --

Object.freeze
Kernel.freeze
# ...

# --

require 'refrigerator'
Refrigerator.freeze_core

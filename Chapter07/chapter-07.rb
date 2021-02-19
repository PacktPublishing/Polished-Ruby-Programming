### Designing Your Library

## Focusing on the user experience

[[1, 2], [3, 4]].to_csv
# => "1,2\n3,4\n"

# --

ToCSV.new([[1,2], [3, 4]]).csv

# --

ToCSV.csv([[1, 2], [3, 4]])

# --

ToCSV.([[1, 2], [3, 4]])

# --

ToCSV[[[1, 2], [3, 4]]]

## Determining the appropriate size for your library

def ToCSV.[](enum)
  convertor = AnyToAny.new
  convertor.input_from(enum, type: :enumerable)
  convertor.output_to(:string, type: :csv)
  convertor.run
  convertor.output
end

## Handling complexity tradeoffs during method design

def first_record
  reset
  next_record
end

# --

def first_n_records(n)
  reset
  ary = []

  n.times do
    break unless record = next_record
    ary << record
  end

  ary
end

# --

def first_matching_record
  reset

  while record = next_record
    if yield record
      return record
    end
  end

  nil
end

# --

def first_n_matching_records(n)
  reset
  ary = []

  while record = next_record
    if yield record
      ary << record
      break if ary.length >= n
    end
  end

  ary
end

# --

def record_at_offset(o)
  reset
  o.times{next_record}
  next_record
end

# --

def first_n_records_starting_at_offset(n, o)
  reset
  o.times{next_record}
  ary = []

  n.times do
    break unless record = next_record
    ary << record
  end

  ary
end

# --

def first_matching_record_starting_at_offset(o)
  reset
  o.times{next_record}

  while record = next_record
    if yield record
      return record
    end
  end

  nil
end

# --

def first_n_matching_records_starting_at_offset(n, o)
  reset
  o.times{next_record}
  ary = []

  while record = next_record
    if yield record
      ary << record
      break if ary.length >= n
    end
  end

  ary
end

# --

o.times{next_record}

# --

def first_record(offset: 0)
  reset
  offset.times{next_record}
  next_record
end

# --

def record_at_offset(o)
  first_record(offset: o)
end

# --

def first_n_records(n, offset: 0)
  reset
  offset.times{next_record}
  ary = []

  n.times do
    break unless record = next_record
    ary << record
  end

  ary
end

# --

def first_n_records(n, offset: 0)
  reset
  offset.times{next_record}
  ary = []

  while record = next_record
    if !block_given? || yield(record)
      ary << record
      break if ary.length >= n
    end
  end

  ary
end

# --

def first_record(offset: 0)
  reset
  offset.times{next_record}

  while record = next_record
    if !block_given? || yield(record)
      return record
    end
  end

  nil
end

# --

def first_n_records(number: (only_one = 1), offset: 0)
  reset
  offset.times{next_record}
  ary = []

  while record = next_record
    if !block_given? || yield(record)
      ary << record
      break if ary.length >= number
    end
  end

  only_one ? ary[0] : ary
end

# --

alias first_record first_n_records

# --

def first_record(offset: 0, &block)
  _first_n_records(offset: offset, &block)
end

def first_n_records(number, offset: 0, &block)
  _first_n_records(number: number, offset: offset, &block)
end

# --

def first_record(**kwargs, &block)
  kwargs.delete(:number)
  _first_n_records(**kwargs, &block)
end

def first_n_records(number, **kwargs, &block)
  kwargs[:number] = number
  _first_n_records(**kwargs, &block)
end

# --

first
first(3)
first{|rec| rec.id == 10}
first(9){|rec| rec.name == 'Ruby'}
first(offset: 7)
first(3, offset: 1)
first(offset: 14){|rec| rec.id == 29}
first(7, offset: 4){|rec| rec.name == 'Knight'}

# --

def first_n_matching_records_starting_at_offset(n, o, &blk)
  _first_n_records(number: n, offset: o, &blk)
end

# --

def first_n_matching_records_starting_at_offset(n, o, &blk)
  raise ArgumentError, "block required" unless blk
  _first_n_records(number: n, offset: o, &blk)
end

## Designing for extensibility

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

book = Libry::Book.new('name')
book.extend(Cursed::Book)

# --

book = Libry::Book.new('name')

m = Libry::Book.instance_method(:checked_out_to=)
book.define_singleton_method(:checked_out_to=, m)

book.extend(Cursed::Book)

# --

user = Libry::User.new(2)
user.checkout(Libry::Book.new('x'))
user.checkout(book)
user.books.length
# => 2

user.checkout(Libry::Book.new('y'))
user.books.length
# => 3

# --

module Cursed
  module Book
    def checked_out_to=(user)
      user.singleton_class.prepend(User)
      super
    end
  end
end

# --

book = Libry::Book.new('name')

m = Libry::Book.instance_method(:checked_out_to=)
book.define_singleton_method(:checked_out_to=, m)

book.singleton_class.prepend(Cursed::Book)

# --

user = Libry::User.new(3)
user.checkout(Libry::Book.new('x'))
user.checkout(book)
user.books.length
# => 2

user.checkout(Libry::Book.new('y'))
user.books.length
# => 2

# --

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
    nil
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
  class Library; end

  module Plugins::Core::LibraryMethods
    attr_reader :users
    attr_reader :books

    def initialize
      @users = []
      @books = []
    end
  end
end

# --

class Libry
  def self.plugin(mod)
    if defined?(mod::BookMethods)
      Book.include(mod::BookMethods)
    end
    if defined?(mod::UserMethods)
      User.include(mod::UserMethods)
    end
    if defined?(mod::LibraryMethods)
      Library.include(mod::LibraryMethods)
    end
  end

  plugin(Plugins::Core)
end

# --

library = Libry::Library.new
library.users << Libry::User.new(1)
library.books << Libry::Book.new('b')

# --

class Libry
  def self.plugin(mod)
    if defined?(mod::BookMethods)
      Book.include(mod::BookMethods)
    end
    if defined?(mod::UserMethods)
      User.include(mod::UserMethods)
    end
    if defined?(mod::LibraryMethods)
      Library.include(mod::LibraryMethods)
    end

# --

    if defined?(mod::BookClassMethods)
      Book.extend(mod::BookClassMethods)
    end
    if defined?(mod::UserClassMethods)
      User.extend(mod::UserClassMethods)
    end
    if defined?(mod::LibraryClassMethods)
      Library.extend(mod::LibraryClassMethods)
    end
    nil
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
  LibraryClassMethods = TrackingMethods
end

# --

Libry.plugin(Libry::Plugins::Tracking)

Libry::Library.new
Libry::Library.tracked.size
# => 1

Libry::Book.new 'a'
Libry::Book.new 'b'
Libry::Book.tracked.size
# => 2

Libry::User.tracked.size
# NoMethodError

# --

class Libry
  def self.plugin(mod)
    # same module include/extend code as before

    mod.after_load if mod.respond_to?(:after_load)
    nil
  end
end

# --

module Libry::Plugins::Tracking
  def self.after_load
    classes = [Libry::Book, Libry::User, Libry::Library]
    classes.each do |klass|
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

Libry::Library.new
Libry::Library.tracked.size
# => 1  # or 2

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

module Libry::Plugins::AutoCurse
  def self.after_load
    Libry.plugin(Libry::Plugins::Cursing)
  end
end

# --

Libry.plugin(Libry::Plugins::AutoCurse)
Libry::Book.new('a')
# no error!

# --

module Libry::Plugins::Cursing
  module BookMethods
    def cursed?
      !!@cursed
    end
  end

  module UserMethods
    def cursed?
      !!@cursed
    end
  end
end

# --

Libry::Book.new('a').cursed?
# => true

# --

user = Libry::User.new 1
book = Libry::Book.new 'a'
user.checkout(book)

Libry.plugin(Libry::Plugins::AutoCurse)

user.curse!
book.cursed?
# => false

# --

user = Libry::User.new 1
book = Libry::Book.new 'a'
user.checkout(book)

Libry.plugin(Libry::Plugins::Cursing)
Libry.plugin(Libry::Plugins::AutoCurse)

user.curse!
book.cursed?
# => true

# --

class Libry
  def self.plugin(mod)
    mod.before_load if mod.respond_to?(:before_load)

    # same module include/extend code as before

    mod.after_load if mod.respond_to?(:after_load)
    nil
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

Libry.plugin(Libry::Plugins::AutoCurse)

user.curse!
book.cursed?
# => true

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

    # rest of method
  end
end

# --

Libry.plugin(:auto_curse)

# --

class Libry
  def self.inherited(subclass)
    subclass.const_set(:Library, Class.new(self::Library))
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
    if defined?(mod::LibraryMethods)
      self::Library.include(mod::LibraryMethods)
    end

# --

    if defined?(mod::BookClassMethods)
      self::Book.extend(mod::BookClassMethods)
    end
    if defined?(mod::UserClassMethods)
      self::User.extend(mod::UserClassMethods)
    end
    if defined?(mod::LibraryClassMethods)
      self::Library.extend(mod::LibraryClassMethods)
    end

# --

    mod.after_load(self) if mod.respond_to?(:after_load)
    nil
  end
end

# --

module Libry::Plugins::Tracking
  def self.after_load(libry)
    classes = [libry::Book, libry::User, libry::Library]
    classes.each do |klass|
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
    libry.plugin(Libry::Plugins::Cursing)
  end
end

# --

l = Class.new(Libry)

user = l::User.new 1
book = l::Book.new 'a'
user.checkout(book)

l.plugin(:auto_curse)

user.curse!
p book.cursed?
# => true

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

    if mod.respond_to?(:before_load)
      mod.after_load(self, ...)
    end
    nil
  end
end

# --

module Libry::Plugins::Tracking
  def self.after_load(libry, &block)
    classes = [libry::Book, libry::User, libry::Library]
    classes.each do |klass|
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
  plugin(Plugins::Tracking)

  Book.freeze
  User.freeze
  Library.freeze
  freeze
end

# --

user = MyLibry::User.new(1)
user.freeze
user.checkout(MyLibry::Book.new('b'))

# --

library = MyLibry::Library.new
library.freeze
library.users << user

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

class Libry
  class Book; end
  class User; end

  PLUGINS = {}

  def self.register_plugin(symbol, mod)
    PLUGINS[symbol] = mod
  end

  def self.inherited(subclass)
    subclass.const_set(:Book, Class.new(self::Book))
    subclass.const_set(:User, Class.new(self::User))
  end

  module Plugins
    module Core
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

  def self.plugin(mod)
    if mod.is_a?(Symbol)
      # Skip in this case as all plugins are in this file
      #require "libry/plugins/#{mod}"
      mod = PLUGINS.fetch(mod)
    end

    mod.before_load(self) if mod.respond_to?(:before_load)

    if defined?(mod::BookMethods)
      self::Book.include(mod::BookMethods)
    end
    if defined?(mod::UserMethods)
      self::User.include(mod::UserMethods)
    end

    if defined?(mod::BookClassMethods)
      self::Book.extend(mod::BookClassMethods)
    end
    if defined?(mod::UserClassMethods)
      self::User.extend(mod::UserClassMethods)
    end

    mod.after_load(self) if mod.respond_to?(:after_load)
  end

  plugin(Plugins::Core)
end

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


      module UserMethods
        def curse!
          @cursed = true
        end

        def checkout(book)
          super unless @cursed
        end
      end

      Libry.register_plugin(:cursing, self)
    end
  end
end

module Libry::Plugins::Tracking
  def self.after_load(libry)
    [libry::Book, libry::User].each do |klass|
      klass.instance_exec{@tracked ||= []}
    end
  end

  module TrackingMethods
    attr_reader :tracked
    def new(*)
      obj = super
      @tracked << obj
      obj
    end
    def inherited(subclass)
      subclass.instance_variable_set(:@tracked, [])
    end
  end

  BookClassMethods = TrackingMethods
  UserClassMethods = TrackingMethods

  Libry.register_plugin(:tracking, self)
end

module Libry::Plugins::AutoCurse
  def self.before_load(libry)
    libry.plugin(:cursing)
  end

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

  Libry.register_plugin(:auto_curse, self)
end

libry = Class.new(Libry)

user = libry::User.new 1
book = libry::Book.new 'a'
user.checkout(book)

libry.plugin(:auto_curse)

user.curse!

user = Libry::User.new 1
user.respond_to?(:curse!)
# => false

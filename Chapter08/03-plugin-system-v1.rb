class Libry
  class Book; end
  class User; end

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
    if defined?(mod::BookMethods)
      Book.include(mod::BookMethods)
    end
    if defined?(mod::UserMethods)
      User.include(mod::UserMethods)
    end
    nil
  end

  plugin(Plugins::Core)
end

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

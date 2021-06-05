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
    end
  end
end

Libry.plugin(Libry::Plugins::Cursing)

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

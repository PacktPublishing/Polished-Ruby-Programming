class Libry
  class User
    def initialize(id)
      @id = id
      @books = []
    end
    def checkout(book)
      book.checked_out_to = self
      @books << book
    end
    attr_accessor :books
  end

  class Book
    def initialize(name)
      @name = name
    end
    def checkin
      checked_out_to.books.delete(self)
      @checked_out_to = nil
    end
    attr_accessor :checked_out_to
  end
end

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

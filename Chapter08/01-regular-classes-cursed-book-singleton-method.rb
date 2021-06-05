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

book = Libry::Book.new('name')

def book.checked_out_to=(user)
  def user.checkout(book)
    nil
  end

  nil
end

user = Libry::User.new(1)
user.checkout(Libry::Book.new('x'))
user.checkout(book)
user.books.length
# => 2

user.checkout(Libry::Book.new('y'))
user.books.length
# => 2

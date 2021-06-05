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

class Libry
  class User
    def checkout(book)
      book.checked_out_to = self
      @books << book
    end
  end
end

class Libry
  class Book
    def checkin
      checked_out_to.books.delete(self)
      @checked_out_to = nil
    end
  end
end

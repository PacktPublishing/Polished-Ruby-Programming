class ArbitraryVisitor
  def visit(obj)
    case obj
    when Integer
      visit_integer(obj)
    when String
      visit_string(obj)
    when Array
      visit_array(obj)
    else
      raise ArgumentError, "unsupported object visited"
    end
  end

  private

  def visit_integer(obj)
    obj ** obj
  end

  def visit_string(obj)
    obj + obj.reverse
  end

  def visit_array(obj)
    obj.size
  end
end

av = ArbitraryVisitor.new

av.visit(4)
# => 256

av.visit("palindrome")
# => "palindromeemordnilap"

av.visit([:a, :b, :c])
# => 3

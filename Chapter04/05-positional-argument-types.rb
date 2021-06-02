def a(x, y=2, z)
  [x, y, z]
end
a(1, 3)
# => [1, 2, 3]

eval(<<END)
  def a(x=1, y, z=2)
  end
END
# SyntaxError

def a(x, y=2, z)
end

eval(<<END)
  def a(x=1, y, z=2)
  end
END

def a(x, y=nil)
end

def a(x=nil, y)
end

def a(y)
end

a(2)

def a(x=nil, y)
end

a(1, 2)

def identifier(column, table=nil)
end

def identifier(table=nil, column)
end

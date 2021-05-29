class HashedArbitraryVisitor
  DISPATCH = {
    Integer => :visit_integer,
    String => :visit_string,
    Array => :visit_array,
  }.freeze

  def visit(obj)
    klass = obj.class
    if meth = DISPATCH[klass]
      send(meth, obj)
    else
      while klass = klass.superclass
        if meth = DISPATCH[klass]
          return send(meth, obj)
        end
      end
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

hav = HashedArbitraryVisitor.new

hav.visit([:a, :b, :c])
# => 3

hav.visit(Class.new(Array)[:a, :b, :c])
# => 3

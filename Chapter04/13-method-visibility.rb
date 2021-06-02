class MethodVis
  protected def foo
    :foo
  end
end

MethodVis.instance_methods(false)
# => [:foo]

m = MethodVis.new
m.methods.include?(:foo)
# => true

m.foo
# NoMethodError

class MethodVis
  private def method_missing(sym, ...)
    if sym == :foo
      warn("foo is a protected method, stop calling it!",
           uplevel: 1)
      return foo(...)
    end
    super
  end
end

m.foo
# foo is a protected method, stop calling it!
# => :foo

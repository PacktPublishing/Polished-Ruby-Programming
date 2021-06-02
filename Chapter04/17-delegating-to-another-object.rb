class A
  attr_accessor :b

  def initialize(b)
    @b = b
  end
end

class A
  def foo(*args, **kwargs, &block)
    b.foo(*args, **kwargs, &block)
  end
end

class A
  def foo(...)
    b.foo(...)
  end
end

class A
  def foo(*args, &block)
    b.foo(*args, &block)
  end
  if respond_to?(:ruby2_keywords, true)
    ruby2_keywords(:foo)
  end
end

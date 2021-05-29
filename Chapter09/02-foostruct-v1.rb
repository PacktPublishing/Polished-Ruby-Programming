class FooStruct
  def initialize(**kwargs)
    @values = kwargs
  end

  def bar
    @values[:bar]
  end

  def bar=(v)
    @values[:bar] = v
  end

  def baz
    @values[:baz]
  end

  def baz=(v)
    @values[:baz] = v
  end
end

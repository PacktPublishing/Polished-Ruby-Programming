def foo(bar, *)
end

def foo(bar, *)
  bar = 2
  super
end

def a(*bar)
end

def a(bar)
end

def a(bar=[])
end

EMPTY_ARRAY = [].freeze
def a(bar=EMPTY_ARRAY)
end

EMPTY_ARRAY = [].freeze
def a(bar=EMPTY_ARRAY)
  bar << 1
end

EMPTY_ARRAY = [].freeze
def a(bar=EMPTY_ARRAY)
  bar = bar.dup
  bar << 1
end

a(:foo, :bar)

a([:foo, :bar])

a(array)

a(*array)

def a(x, *y)
end

def a(x, y=nil, *z)
end

def a(*y, z)
end

def mv(source, *sources, dir)
  sources.unshift(source)
  sources.each do |source|
    move_into(source, dir)
  end
end

mv("foo", "dir")
mv("foo", "bar", "baz", "dir")

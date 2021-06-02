def foo(bar)
  yield(bar, @baz)
end

foo(1) do |bar, baz|
  bar + baz
end

def foo(bar)
  yield(bar, @baz, @initial || 0)
end

foo(1) do |bar, baz|
  bar + baz
end

foo(1) do |bar, baz, initial|
  bar + baz + initial
end

adder = -> (bar, baz) do
  bar + baz
end

# Worked before, now broken
foo(1, &adder)

def foo(bar, include_initial: false)
  if include_initial
    yield(bar, @baz, @initial || 0)
  else
    yield(bar, @baz)
  end
end

def foo(bar, &block)
  case block.arity
  when 2, -1, -2
    yield(bar, @baz)
  else
    yield(bar, @baz, @initial || 0)
  end
end

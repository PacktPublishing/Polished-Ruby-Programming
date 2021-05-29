module Foo
  class Error < StandardError
  end

  def foo(bar)
    unless allowed?(bar)
      raise Error, "bad bar: #{bar.inspect}"
    end
  end
end

module Foo
  class TransientError < Error
  end
end

begin
  foo(bar)
rescue Foo::TransientError
  sleep(3)
  retry
end

begin
  foo(bar)
rescue Foo::Error => e
  if e.message =~ /\Abad bar: /
    handle_bad_bar(bar)
  else
    raise
  end
end

module Foo
  class BarError < Error
  end

  def foo(bar)
    unless allowed?(bar)
      raise BarError, "bad bar: #{bar.inspect}"
    end
  end
end

begin
  foo(bar)
rescue Foo::BarError
  handle_bad_bar(bar)
end

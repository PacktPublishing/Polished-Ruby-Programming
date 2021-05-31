class SymbolStack
  def initialize
    @stack = []
  end

  def push(sym)
    raise TypeError, "can only push symbols onto stack" unless sym.is_a?(Symbol)
    @stack.push([sym, clock_time])
  end

  def pop
    sym, pushed_at = @stack.pop
    [sym, clock_time - pushed_at]
  end

  private def clock_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
end

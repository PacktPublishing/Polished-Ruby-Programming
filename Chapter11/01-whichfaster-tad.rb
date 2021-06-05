class WhichFaster
  def faster_one(callable1, callable2)
    t1 = time{callable1.call}
    t2 = time{callable2.call}
    t1 > t2 ? callable2 : callable1
  end
  private def time
    t = clock_time
    yield
    clock_time - t
  end
  private def clock_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
end

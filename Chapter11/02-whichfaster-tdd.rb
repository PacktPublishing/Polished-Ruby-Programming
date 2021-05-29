describe WhichFaster do
  it "returns faster callable" do
    which = WhichFaster.new
    c1 = which.callable1 = ->{a}
    c2 = which.callable2 = ->{b}

    which.timer = {c1=>1, c2=>2}
    _(which.faster_one).must_equal c1

    which.timer = {c1=>2, c2=>1}
    _(which.faster_one).must_equal c2
  end
end

class WhichFaster
  attr_accessor :callable1, :callable2, :timer

  def faster_one
    t1 = timer[callable1]
    t2 = timer[callable2]
    t1 > t2 ? callable2 : callable1
  end
end

which = WhichFaster.new
which.callable1 = callable1
which.callable2 = callable2
which.timer = ->(callable) do
  t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  callable.call
  Process.clock_gettime(Process::CLOCK_MONOTONIC) - t
end
which.faster_one

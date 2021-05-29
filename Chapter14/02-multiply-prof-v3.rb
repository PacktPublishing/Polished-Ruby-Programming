class MultiplyProf
  def initialize(vals)
    @vals = vals
  end

  def integer
    @vals[0].to_i * @vals[1].to_i
  end
  def float
    @vals[0].to_f * @vals[1].to_f
  end
  def rational
    @vals[0].to_r * @vals[1].to_r
  end
end

require 'benchmark/ips'

Benchmark.ips do |x|
  x.report("MultiplyProf") do
    MultiplyProf.new([2.4r, 4.2r]).integer
    MultiplyProf.new([2.4r, 4.2r]).float
    MultiplyProf.new([2.4r, 4.2r]).rational
  end
end

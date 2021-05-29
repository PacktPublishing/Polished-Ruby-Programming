class MultiplyProf
  attr_reader :integer
  attr_reader :float
  attr_reader :rational

  def initialize(vals)
    v1, v2 = vals
    @integer = v1.to_i * v2.to_i
    @float = v1.to_f * v2.to_f
    @rational = v1.to_r * v2.to_r
  end
end

mp = MultiplyProf.new([2.4r, 4.2r])
Benchmark.ips do |x|
  x.report("MultiplyProf") do
    mp.integer
    mp.float
    mp.rational
  end
end

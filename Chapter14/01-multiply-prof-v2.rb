class MultiplyProf
  def initialize(vals)
    v1, v2 = vals
    @i1, @i2 = v1.to_i, v2.to_i
    @f1, @f2 = v1.to_f, v2.to_f
    @r1, @r2 = v1.to_r, v2.to_r
  end
  def integer
    @i1 * @i2
  end
  def float
    @f1 * @f2
  end
  def rational
    @r1 * @r2
  end
end

mp = MultiplyProf.new([2.4r, 4.2r])

mp.integer
# => 8

mp.float
# => 10.08

mp.rational
# => (252/25)

require 'ruby-prof'

result = RubyProf.profile do
  i = 0
  while i < 1000
    mp = MultiplyProf.new([2.4r, 4.2r])
    mp.integer
    mp.float
    mp.rational
    i += 1
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

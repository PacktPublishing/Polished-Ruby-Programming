class MultiplyProf
  def initialize(vals)
    @i1, @i2 = vals.map(&:to_i)
    @f1, @f2 = vals.map(&:to_f)
    @r1, @r2 = vals.map(&:to_r)
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
  1000.times do
    mp = MultiplyProf.new([2.4r, 4.2r])
    mp.integer
    mp.float
    mp.rational
  end
end

# print a graph profile to text
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT, {})

require 'benchmark'

Benchmark.realtime do
  2000000.times do
    mp = MultiplyProf.new([2.4r, 4.2r])
    mp.integer
    mp.float
    mp.rational
  end
end

require 'benchmark/ips'

Benchmark.ips do |x|
  x.report("MultiplyProf") do
    mp = MultiplyProf.new([2.4r, 4.2r])
    mp.integer
    mp.float
    mp.rational
  end
end

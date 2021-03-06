### 14
### Optimizing Your Library

## Profiling first, optimizing second

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

# --

mp = MultiplyProf.new([2.4r, 4.2r])

mp.integer
# => 8

mp.float
# => 10.08

mp.rational
# => (252/25)

# --

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

# --

require 'benchmark'

Benchmark.realtime do
  2000000.times do
    mp = MultiplyProf.new([2.4r, 4.2r])
    mp.integer
    mp.float
    mp.rational
  end
end
# => 6.9715518148150295

# --

require 'benchmark/ips'

Benchmark.ips do |x|
  x.report("MultiplyProf") do
    mp = MultiplyProf.new([2.4r, 4.2r])
    mp.integer
    mp.float
    mp.rational
  end
end

# --

class MultiplyProf
  def initialize(vals)
    @i1, @i2 = vals.map(&:to_i)
    @f1, @f2 = vals.map(&:to_f)
    @r1, @r2 = vals.map(&:to_r)
  end
end

# --

class MultiplyProf
  def initialize(vals)
    v1, v2 = vals
    @i1, @i2 = v1.to_i, v2.to_i
    @f1, @f2 = v1.to_f, v2.to_f
    @r1, @r2 = v1.to_r, v2.to_r
  end
end

# --

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

## Understanding that no code is faster than no code

Benchmark.ips do |x|
  x.report("MultiplyProf") do
    MultiplyProf.new([2.4r, 4.2r]).integer
    MultiplyProf.new([2.4r, 4.2r]).float
    MultiplyProf.new([2.4r, 4.2r]).rational
  end
end
# 189.666k i/s

# --

class MultiplyProf
  def initialize(vals)
    # do nothing
  end
end

# --

class MultiplyProf
  def initialize(vals)
    @vals = vals
  end

# --

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

# --

mp = MultiplyProf.new([2.4r, 4.2r])
Benchmark.ips do |x|
  x.report("MultiplyProf") do
    mp.integer
    mp.float
    mp.rational
  end
end
# 2.130M i/s

# --

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

# --

class MultiplyProf
  def initialize(vals)
    @vals = vals
  end
  def integer
    @integer ||= @vals[0].to_i * @vals[1].to_i
  end
  def float
    @float ||= @vals[0].to_f * @vals[1].to_f
  end
  def rational
    @rational ||= @vals[0].to_r * @vals[1].to_r
  end
end

# --

Benchmark.ips do |x|
  x.report("MultiplyProf") do
    MultiplyProf.new([2.4r, 4.2r]).integer
    MultiplyProf.new([2.4r, 4.2r]).float
    MultiplyProf.new([2.4r, 4.2r]).rational
  end
end
# 301.952k i/s

## Handling code where everything is slow

array[0]
# and
array[-1]

# --

array.first
# and
array.last

# --

Hash[hash]

# --

hash.dup

# --

Hash[hash].merge!(hash2)

# --

hash.merge(hash2)

# --

def foo(bar=(bar_not_given = true))
  return :bar if bar_not_given
  :foo
end

# --

# Doesn't work:
#def foo(bar=(return :bar))
#  :foo
#end

# --

def foo(bar=(return :bar; nil))
  :foo
end

# --

def foo(bar=nil || (return :bar))
  :foo
end

### Formatting Code for Easy Reading

## Recognizing different perspectives to code formatting

bar if foo

# --

if foo
  bar
end

# --

foo and bar

# --

return unless condition

# --

unless condition
  return
end

# --

if !condition
  return
end

# --

condition or return

## Learning how syntactic consistency affects maintainability

if !condition
  return
end

# --

return unless condition

# --

it "foo should be true" do
  foo.must_equal true
end if RUBY_VERSION >= '3.0'

# --

if RUBY_VERSION >= '3.0'
  it "foo should be true" do
    foo.must_equal true
  end
end

## Understanding that arbitrary limits usually result in worse code

class XYZPoint
  def all_combinations(array)
    xs.each do |x|
      ys.each do |y|
        zs.each do |z|
          array.each do |val|
            yield x, y, z, val
          end
        end
      end
    end
  end
end

# --

class XYZPoint
  private def each_xy
    xs.each do |x|
      ys.each do |y|
        yield x, y
      end
    end
  end

# --

  def all_combinations(array)
    xys.each do |x, y|
      zs.each do |z|
        array.each do |val|
          yield x, y, z, val
        end
      end
    end
  end
end

# --

CSV.new(data,
        nil_value: "",
        strip: true,
        skip_lines: /foo/)

# --

CSV.new(data,
        col_sep: "\t",
        row_sep: "\0",
        quote_char: "|")

# --

options = CSV::Options.new
options.nil_value = ""
options.strip = true
options.skip_lines = true
CSV.new(data, options)

# --

options = CSV::Options.new
options.col_sep = "\t"
options.row_sep = "\0"
options.quote_char = "|"
CSV.new(data, options)

# --

options = CSV::Options.new
options.nil_value = ""
options.strip = true
options.skip_lines = true
csv1 = CSV.new(data1, options)
csv2 = CSV.new(data2, options)

# --

options = {nil_value: "", strip: true, skip_lines: /foo/}
csv1 = CSV.new(data1, **options)
csv2 = CSV.new(data2, **options)

# --

def foo(arg)
  bar, baz = _foo_1(arg)
  val = _foo_2(bar)
  _foo_3(val, baz)
end

## Realizing the actual importance of code formatting

  def       fed
  ( p       p )
  p?a       a?p

  q=   p q   =p
  p %%.....%% q
  dne       end

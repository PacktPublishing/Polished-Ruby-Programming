class Foo
  attr_accessor :bar

  def branch(v)
    v > 1 ? bar : baz
  end

  def baz; raise; end
end

describe Foo do
  it "#branch should return the value of bar" do
    foo = Foo.new
    foo.bar = 3
    (foo.branch(2)).must_equal 3
  end
end

describe Foo do
  it "#branch should return the value of bar" do
    Foo.new.branch(0) rescue nil
    Foo.new.branch(2) rescue nil
  end
end

class Foo
  singleton_class.alias_method(:build, :new)

  def build_foo(arg)
    Foo.build(arg)
  end
end

describe Foo do
  it "#build_foo should call Foo.build" do
    mock = Minitest::Mock.new
    mock.expect :call, :foo, [1]

    Foo.stub :build, mock do
      _(Foo.new.build_foo(1)).must_equal :foo
    end

    mock.verify
  end
end

class Foo
  def build_foo(arg)
    Foo.new(arg)
  end
end

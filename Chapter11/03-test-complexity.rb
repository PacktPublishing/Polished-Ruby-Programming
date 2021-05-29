describe Foo do
  it "should have bar return a Bar instance" do
    _(Foo.new.bar).must_be_kind_of(Bar)
  end

  it "should have baz return a Baz instance" do
    _(Foo.new.baz).must_be_kind_of(Baz)
  end

  it "should have quux return a Quux instance" do
    _(Foo.new.quux).must_be_kind_of(Quux)
  end
end

describe Foo do
  def method_must_return_kind_of(meth, instance)
    _(Foo.new.send(meth)).must_be_kind_of(instance)
  end

  it "should have bar return a Bar instance" do
    method_must_return_kind_of(:bar, Bar)
  end

  it "should have baz return a Baz instance" do
    method_must_return_kind_of(:baz, Baz)
  end

  it "should have quux return a Quux instance" do
    method_must_return_kind_of(:quux, Quux)
  end
end

describe Foo do
  {bar: Bar, baz: Baz, quux: Quux}.each do |meth, klass|
    it "should have #{meth} return a #{klass} instance" do
      _(Foo.new.send(meth)).must_be_kind_of(klass)
    end
  end
end

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

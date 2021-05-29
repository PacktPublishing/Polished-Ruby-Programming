module Rusty
  def self.struct(&block)
    klass = Class.new
    klass.extend(self)
    klass.class_eval(&block)
    klass
  end

  def fn(meth, &block)
    define_method(meth, &block)
  end

  def vl(meth, value)
    define_method(meth){value}
  end
end

Baz = Rusty.struct do
  fn :rand do
    Time.now.usec/1000000.0
  end

  vl :class_name, :Baz
end

Baz.new.rand
# some float between 0.0 and 1.0

Baz.new.class_name
# => :Baz

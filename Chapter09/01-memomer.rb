module Memomer
  def self.extended(klass)
    mod = Module.new
    klass.prepend(mod)
    klass.instance_variable_set(:@memomer_mod, mod)
  end

  def memoize(arg)
    iv = :"@memomer_#{arg}"
    @memomer_mod.define_method(arg) do
      if instance_variable_defined?(iv)
        return instance_variable_get(iv)
      end
      v = super()
      instance_variable_set(iv, v)
      v
    end
  end
end

class MetaStruct
  def self.method_missing(meth, arg=nil, &block)
    block ||= proc{arg}
    define_method(meth, &block)
  end
end

class A < MetaStruct
  extend Memomer
  memoize :bar
end

a = A.new
a.bar
# => [1, 1, 1]

A.foo 2

A.new.bar
# => [2, 2, 2]

a.bar
# => [1, 1, 1]

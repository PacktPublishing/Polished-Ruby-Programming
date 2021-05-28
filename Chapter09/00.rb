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

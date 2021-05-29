module Rusty
  def fn(meth, code)
    self << "def #{meth}; #{code}; end;"
  end

  alias vl fn

  def self.struct(name, &block)
    meths = []
    meths.extend(self)
    meths.instance_eval(&block)
    klass = eval(<<-END)
      class ::#{name}
        #{meths.join}
        self
      end
    END
    klass
  end
end

Rusty.struct(:Baz) do
  fn :rand, "Time.now.usec/1000000.0"
  vl :class_name, ":Baz"
end

Baz.new.rand
# some float between 0.0 and 1.0

Baz.new.class_name
# => :Baz

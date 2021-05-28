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

class MetaStruct
  def self.method_missing(meth, arg=nil, &block)
    block ||= proc{arg}
    define_method(meth, &block)
  end
end

class A < MetaStruct
  b
  foo 1
  bar{3.times.map{foo}}
end

A.new.b
# => nil

A.new.foo
# => 1

A.new.bar
# => [1, 1, 1]

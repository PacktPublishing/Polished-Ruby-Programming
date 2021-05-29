class A
  @c = 1

  def self.inherited(subclass)
    subclass.instance_variable_set(:@c, @c)
  end
end

class B < A
  @c # 1
end

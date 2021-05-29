class Foo
  BAR = 1
  deprecate_constant :BAR
end

class Foo
  BAR = 1
  BAR_ = BAR
  private_constant :BAR_
  deprecate_constant :BAR
end

class Object
  Foo_ = Foo
  private_constant :Foo_
  deprecate_constant :Foo
end

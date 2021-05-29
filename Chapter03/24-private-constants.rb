class A
  X = 2
  private_constant :X
end

A::X
# NameError

A::X = 3
# warning: already initialized constant A::X

A::X
# NameError

class A
  public_constant :X
end

A::X # 3

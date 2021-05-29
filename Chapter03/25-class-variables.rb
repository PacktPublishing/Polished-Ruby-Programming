class A
  @@a = 1

  class << self
    @@a
  end

  def b
    @@a
  end
end

class B < A
  @@a
end

class B
  @@a = 2
end

A.new.b # 2

class B
  @@b = 3

  def c
    @@b
  end
end

B.new.c # 3

class A
  @@b # NameError
end

class A
  @@b = 4
end

B.new.c
# RuntimeError (class variable @@b of B is overtaken by A)

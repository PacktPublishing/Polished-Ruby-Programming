class A
  C = 1
end

class B < A
  C # 1
end

class B
  C = 2
end

class B
  C # 2
end

class A
  C # 1
end

class B
  C += 1 # warning
end

class B
  def increment
    # would be SyntaxError, dynamic constant assignment
    # C += 1
  end
end

class B
  def increment
    self.class.const_set(:C, C + 1)
  end
end

class B
  C = [0]
  def increment
    C[0] += 1
  end
end

class A
  @c = 1
end

class B < A
end

def A.c
  if defined?(@c)
    @c
  else
    klass = self
    while klass = klass.superclass
      if klass.instance_variable_defined?(:@c)
        return klass.instance_variable_get(:@c)
      end
    end
  end
end

A.c # 1
B.c # 1

class B
  @c = 2
end

A.c # 1
B.c # 2

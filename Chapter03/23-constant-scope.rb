class A
  W = 0
  X = 1
  Y = 2
  Z = 3
end

class Object
  U = -1
  Y = -2
end


class B < A
  X = 4
  Z = 5
end


class B
  U # -1, from Object
  W # 0, from A
  X # 4, from B
  Y # 2, from A
  Z # 5, from B
end

class C < A
  Y = 6
end

class D
  Z = 7
end

class E < D
  W = 8
end

class E
  class ::C
    U # -1, from Object
    W # 8, from E
    X # 1, from A
    Y # 6, from C
    Z # 3, from A
  end
end

class C
  class ::E
    U # -1, from Object
    W # 8 from E
    X # NameError
    Y # 6, from C
    Z # 7, from D
  end
end

class B
  class ::C
    class ::E
      U # -1, from Object
      W # 8 from E
      X # 4, from B
      Y # 6, from C
      Z # 5, from B
    end
  end
end

class A
  @c = 1
end

class B < A
end

def A.c
  defined?(@c) ? @c : superclass.c
end

A.c # 1
B.c # 1

class B
  @c = 2
end

A.c # 1
B.c # 2

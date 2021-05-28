defined?(a) # nil
a = 1
defined?(a) # 'local-variable'
module M
  defined?(a) # nil
  a = 2
  defined?(a) # 'local-variable'
  class C
    defined?(a) # nil
    a = 3
    defined?(a) # 'local-variable'
    def m
      defined?(a) # nil
      a = 4
      defined?(a) # 'local-variable'
    end

    a # 3
  end
  a # 2
end
a # 1

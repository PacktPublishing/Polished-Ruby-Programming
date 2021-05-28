defined?(a) # nil
a = 1
defined?(a) # 'local-variable'
M = Module.new do
  defined?(a) # 'local-variable'
  a = 2
  self::C = Class.new do
    defined?(a) # 'local-variable'
    a = 3
    define_method(:m) do
      defined?(a) # 'local-variable'
      a = 4
    end

    a # 3
  end
   a # 3
end
a # 3

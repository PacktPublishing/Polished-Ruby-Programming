require 'deprecate_public'

class MethodVis
  deprecate_public :foo
end

class ConstantVis
  deprecate_public_constant :PRIVATE
end

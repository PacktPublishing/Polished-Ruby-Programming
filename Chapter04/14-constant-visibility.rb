class ConstantVis
  PRIVATE = 1
  private_constant :PRIVATE
end

ConstantVis::PRIVATE
# NameError

# --

class ConstantVis
  def self.const_missing(const)
    if const == :PRIVATE
      warn("ConstantVis::PRIVATE is a private constant, " \
           "stop accessing it!", uplevel: 1)
      return PRIVATE
    end
    super
  end
end

ConstantVis::PRIVATE
# ConstantVis::PRIVATE is a private constant,
# stop accessing it!
# => 1

class Max
  def initialize(max)
    @max = max
  end

  def over?(n)
    @max < n
  end
end

class MaxBy < Max
  def over?(n, by)
    @max > n + by
  end
end

class MaxBy < Max
  def over?(n, by: 0)
    @max > n + by
  end
end

if obj.instance_of?(Max)
  # do something
else
  # do something else
end

if obj.class == Max
  # do something
else
  # do something else
end

if obj.kind_of?(Max)
  # do something
else
  # do something else
end

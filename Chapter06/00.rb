class XYZPoint
  private def each_xy
    xs.each do |x|
      ys.each do |y|
        yield x, y
      end
    end
  end

  def all_combinations(array)
    each_xy do |x, y|
      zs.each do |z|
        array.each do |val|
          yield x, y, z, val
        end
      end
    end
  end
end

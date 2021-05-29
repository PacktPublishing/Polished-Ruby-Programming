class TimeFilter
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
  end

  def to_proc
    start = self.start
    finish = self.finish

    if start && finish
      proc{|value| value >= start && value <= finish}
    elsif start
      proc{|value| value >= start}
    elsif finish
      proc{|value| value <= finish}
    else
      proc{|value| true}
    end
  end
end

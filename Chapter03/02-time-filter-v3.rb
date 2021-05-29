class TimeFilter
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
  end

  def to_proc
    start = self.start
    finish = self.finish

    proc do |value|
      next false if start && value < start
      next false if finish && value > finish
      true
    end
  end
end

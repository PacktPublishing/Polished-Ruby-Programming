class CurrentDay
  def initialize(date: Date.today,
                 schedule: MonthlySchedule.new(date.year,
                                               date.month))
    @date = date
    @schedule = schedule
  end

  def work_hours
    @schedule.work_hours_for(@date)
  end

  def workday?
    !@schedule.holidays.include?(@date)
  end
end

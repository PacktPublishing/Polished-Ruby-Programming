class BrokenCircuit
  def initialize(num_failures: 3, within: 60)
    @num_failures = num_failures
    @within = within
    @failures = []
  end


  def check
    if @failures.length >= @num_failures
      cutoff = Time.now - @within
      @failures.reject!{|t| t < cutoff}
      return if @failures.length >= @num_failures
    end

    begin
      yield
    rescue
      @failures << Time.now
      nil
    end
  end
end

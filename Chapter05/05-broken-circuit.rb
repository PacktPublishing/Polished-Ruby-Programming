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

RECOMMENDER_CIRCUIT = BrokenCircuit.new
AD_CIRCUIT = BrokenCircuit.new

@recommendations = RECOMMENDER_CIRCUIT.check do
  recommender_service.call(timeout: 3)
end
@ads = AD_CIRCUIT.check do
  ad_service.call(timeout: 3)
end
process_payment

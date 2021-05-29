INVOICES_PROCESSED = Object.new
INVOICES_PROCESSED.instance_eval do
  @processed = 0

  def processed
    @processed += 1
    if @processed % 100 == 0
      print '.'
    end
  end
end

INVOICES_PROCESSED.processed

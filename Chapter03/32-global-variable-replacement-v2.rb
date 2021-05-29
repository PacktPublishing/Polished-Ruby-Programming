class Invoice
  @number_processed = 0
  singleton_class.send(:attr_accessor, :number_processed)
end

Invoice.number_processed += 1
if Invoice.number_processed % 100 == 0
  print '.'
end

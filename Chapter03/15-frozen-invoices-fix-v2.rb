LineItem = Struct.new(:name, :price, :quantity)

class Invoice
  def initialize(line_items, tax_rate)
    @line_items = line_items.freeze
    @tax_rate = tax_rate
    @cache = {}
    freeze
  end

  def total_tax
    return @cache[:total_tax] if @cache.key?(:total_tax)
    @cache[:total_tax] = @tax_rate *
      @line_items.sum do |item|
        item.price * item.quantity
      end
  end
end

line_items = [LineItem.new('Foo', 3.5r, 10)]
invoice = Invoice.new(line_items, 0.095r)
tax_was = invoice.total_tax
line_items << LineItem.new('Bar', 4.2r, 10)
tax_is = invoice.total_tax

LineItem = Struct.new(:name, :price, :quantity)

class Invoice
  def initialize(line_items, tax_rate)
    @line_items = line_items
    @tax_rate = tax_rate
    @cache = {}
    freeze
  end

  def total_tax
    @cache[:total_tax] ||= @tax_rate *
      @line_items.sum do |item|
        item.price * item.quantity
      end
  end
end

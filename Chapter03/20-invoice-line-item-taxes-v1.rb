LineItem = Struct.new(:name, :price, :quantity)

class Invoice
  def initialize(line_items, tax_rate)
    @line_items = line_items.map do |item|
      item.dup.freeze
    end.freeze
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

  def line_item_taxes
    @line_items.map do |item|
      @tax_rate * item.price * item.quantity
    end
  end
end

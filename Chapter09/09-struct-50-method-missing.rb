class Struct50
  def method_missing(meth, *)
    @fields.fetch(meth){super}
  end

  def respond_to_missing?(meth, *)
    @fields.include?(meth)
  end
end

Struct50.new.respond_to?(:valid_field)
# false when using method_missing without
# respond_to_missing?

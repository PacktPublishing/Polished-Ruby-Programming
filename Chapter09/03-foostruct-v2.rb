class FooStruct
  def initialize(**kwargs)
    @values = kwargs
  end

  %i[bar baz].each do |field|
    define_method(field) do
      @values[field]
    end

    define_method(:"#{field}=") do |v|
      @values[field] = v
    end
  end
end

foo = FooStruct.new
foo.bar = 1
foo.baz = 2

foo.bar
# => 1

foo.baz
# => 2

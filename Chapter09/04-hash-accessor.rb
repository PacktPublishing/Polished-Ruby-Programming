module HashAccessor
  def hash_accessor(iv, *fields)
    fields.each do |field|
      define_method(field) do
        instance_variable_get(iv)[field]
      end

      define_method(:"#{field}=") do |v|
        instance_variable_get(iv)[field] = v
      end
    end
  end
end

class FooStruct
  def initialize(**kwargs)
    @values = kwargs
  end

  extend HashAccessor
  hash_accessor :@values, :bar, :baz
end

foo = FooStruct.new
foo.bar = 1
foo.baz = 2

foo.bar
# => 1

foo.baz
# => 2

class Bar
  @options = {:foo=>1, :baz=>2}
end

class Bar
  extend HashAccessor
  hash_accessor :@options, :foo, :baz
end

Bar.foo
# NoMethodError

class Bar
  singleton_class.extend HashAccessor
  singleton_class.hash_accessor :@options, :foo, :baz
end

Bar.foo = 1
Bar.baz = 2

Bar.foo
# => 1

Bar.baz
# => 2

Bar.singleton_class.extend HashAccessor

Bar.singleton_class.singleton_class.include HashAccessor

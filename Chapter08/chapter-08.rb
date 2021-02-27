### Metaprogramming and When to Use It

## Learning the pros and cons of abstraction

class A
  def b
    nil
  end
end

# --

def_class = ->(sym, method_hash) do
  c = Object.const_set(sym, Class.new)
  method_hash.each do |meth, val|
    c.define_method(meth){val}
  end
end

def_class.call(:A, b: nil)

# --

class MetaStruct
  def self.method_missing(meth, arg=nil, &block)
    block ||= proc{arg}
    define_method(meth, &block)
  end
end

# --

class A < MetaStruct
  b
  foo 1
  bar{3.times.map{foo}}
end

A.new.b
# => nil

A.new.bar
# => [1, 1, 1]

# --

module Memomer
  def self.extended(klass)
    mod = Module.new
    klass.prepend(mod)
    klass.instance_variable_set(:@memomer_mod, mod)
  end

# --

  def memoize(arg)
    iv = :"@memomer_#{arg}"
    @memomer_mod.define_method(arg) do
      if instance_variable_defined?(iv)
        return instance_variable_get(iv)
      end
      v = super()
      instance_variable_set(iv, v)
      v
    end
  end
end

# --

class A < MetaStruct
  extend Memomer
  memoize :bar
end

# --

a = A.new
a.bar
# => [1, 1, 1]

A.foo 2

A.new.bar
# => [2, 2, 2]

a.bar
# => [1, 1, 1]

## Eliminating redundancy

class Foo
  def bar
    @bar
  end

  def bar=(v)
    @bar = v
  end

  def baz
    @baz
  end

  def baz=(v)
    @baz = v
  end
end

# --

class Foo
  attr_accessor :bar, :baz
end

# --

class FooStruct
  def initialize(**kwargs)
    @values = kwargs
  end

# --

  def bar
    @values[:bar]
  end

  def bar=(v)
    @values[:bar] = v
  end

  def baz
    @values[:baz]
  end

  def baz=(v)
    @values[:baz] = v
  end
end

# --

class FooStruct
  %i[bar baz].each do |field|
    define_method(field) do
      @values[field]
    end

    define_method(:"#{field}=") do |v|
      @values[field] = v
    end
  end
end

# --

foo = FooStruct.new
foo.bar = 1
foo.baz = 2

foo.bar
# => 1

foo.bar
# => 2

# --

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

# --

class FooStruct
  extend HashAccessor
  hash_accessor :@values, :bar, :baz
end

# --

foo = FooStruct.new
foo.bar = 1
foo.baz = 2

foo.bar
# => 1

foo.baz
# => 2

# --

class Bar
  @options = {:foo=>1, :baz=>2}
end

# --

class Bar
  extend HashAccessor
  hash_accessor :@options, :foo, :baz
end

Bar.foo
# NoMethodError

# --

class Bar
  singleton_class.extend HashAccessor
  singleton_class.hash_accessor :@options, :foo, :baz
end

# --

Bar.foo = 1
Bar.baz = 2

Bar.foo
# => 1

Bar.baz
# => 2

# --

Bar.singleton_class.extend HashAccessor

# --

Bar.singleton_class.singleton_class.include HashAccessor

## Understanding different ways of metaprogramming methods

Class.new do
  # class-level block metaprogramming
end

Module.new do
  # module-level block metaprogramming
end

define_singleton_method(:method) do
  # singleton-method defining block metaprogramming
end

# --

module Rusty
  def self.struct(&block)
    klass = Class.new
    klass.extend(self)
    klass.class_eval(&block)
    klass
  end

  def fn(meth, &block)
    define_method(meth, &block)
  end

  def vl(meth, value)
    define_method(meth){value}
  end
end

# --

Baz = Rusty.struct do
  fn :rand do
    Time.now.usec/1000000.0
  end

  vl :class_name, :Baz
end

# --

Baz.new.rand
# some float between 0.0 and 1.0

Baz.new.class_name
# => :Baz

# --

module Rusty
  def fn(meth, code)
    self << "def #{meth}; #{code}; end;"
  end

  alias vl fn

# --

  def self.struct(name, &block)
    meths = []
    meths.extend(self)
    meths.instance_eval(&block)
    klass = eval(<<-END)
      class ::#{name}
        #{meths.join}
        self
      end
    END
    klass
  end
end

# --

Rusty.struct(:Baz) do
  fn :rand, "Time.now.usec/1000000.0"
  vl :class_name, ":Baz"
end

# --

Baz.new.rand
# some float between 0.0 and 1.0

Baz.new.class_name
# => :Baz

# --

Baz.class_eval "def #{name}; :foo end"

# --

if /\A[A-Za-z_][A-Za-z0-9_]*\z/.match?(name)
  Baz.class_eval "def #{name}; :foo end"
else
  Baz.define_method(name){:foo}
end

## Using method_missing judiciously

words{this is a list of words}
# => [:this, :is, :a, :list, :of, :words]

# --

def words(&block)
  array = []

  Class.new(BasicObject) do
    define_method(:method_missing) do |meth, *|
      array << meth
    end
  end.new.instance_exec(&block)

  array.reverse
end

# --

class Struct50
  def method_missing(meth, *)
    @fields.fetch?(meth){super}
  end
end

# --

class Struct50
  valid_fields.each do |field|
    define_method(field){@fields[field]}
  end
end

# --

class Struct50
  def respond_to_missing(*)
    true
  end
end

# --

Struct50.new.respond_to?(:valid_field)
# false when using method_missing without
# respond_to_missing?

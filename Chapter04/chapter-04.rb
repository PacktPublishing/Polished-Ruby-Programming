### Methods and Their Arguments

## Understanding that there are no class methods, only instance methods

class Foo
  def self.bar
    :baz
  end
end

# --

class Foo
end

def Foo.bar
  :baz
end

# --

def (Foo = Class.new).bar
  :baz
end

# --

class Foo
  class << self
    def bar
      :baz
    end
  end
end

# --

class Foo
end

class << Foo
  def bar
    :baz
  end
end

# --

Foo.instance_eval do
  def bar
    :baz
  end
end

# --

class Foo
  def self.bar
    :baz
  end
end

# --

class Foo
  class << self
    private

    def bar
      :baz
    end

    alias baz bar
    remove_method :bar
  end
end

# --

class Foo
  def self.bar
    :baz
  end
  private_class_method :bar

  singleton_class.alias_method :baz, :bar
  singleton_class.remove_method :bar
end

# --

class Foo
  define_singleton_method(:bar) do
    :baz
  end
end

## Naming methods

DB.from(Sequel.identifier(:a).qualify(:b)).
  first(:id=>1)

# --

DB[Sequel[:b][:a]][:id=>1]

## Using the many types of method arguments

h = Hash.new(0)
o = Object.new
o.methods.
  each do |m|
    h[o.method(m).arity] += 1
  end
h
# => {0=>23, -1=>17, 1=>17, 2=>1}

# --

def method_name(positional_argument)
end

# --

File.rename('file1', 'file2')

# --

class C
  alias_method :destination_method, :source_method
end

# --

alias $destination $source

# --

class Screen
  def draw_box(x1, y1, x2, y2)
  end
end

# --

Box = Struct.new(:x1, :y1, :x2, :y2)

class Screen
  def draw_box(box)
  end
end

# --

screen.draw_box(0, 0, 10, 20)

# --

screen.draw_box(Box.new(0, 0, 10, 20))

# --

box = Box.new
box.x1 = 0
box.x2 = 10
box.y1 = 0
box.y2 = 20
screen.draw_box(box)

# --

class Screen
  def draw_box(x1:, y1:, x2:, y2:)
  end
end

# --

screen.draw_box(x1: 0, x2: 0, y1: 0, y2: 20)

# --

class Screen
  def draw_box(_x1=nil, _y1=nil, _x2=nil, _y2=nil,
               x1:_x1, y1:_y1, x2:_x2, y2:_y2)
    raise ArgumentError unless x1 && x2 && y1 && y2
  end
end

# --

screen.draw_box(0, 10, 0, 20)
screen.draw_box(x1: 0, x2: 0, y1: 0, y2: 20)

# --

screen.draw_box(5, 30, 15, 40,
                x1: 0, x2: 0, y1: 0, y2: 20)

# --

def a(x, y=2, z)
  [x, y, z]
end
a(1, 3)
# => [1, 2, 3]

# --

eval(<<END)
  def a(x=1, y, z=2)
  end
END
# SyntaxError

# --

def a(x, y=2, z)
end

# --

eval(<<END)
  def a(x=1, y, z=2)
  end
END

# --

def a(x, y=nil)
end

# --

def a(x=nil, y)
end

# --

def a(y)
end

# --

a(2)

# --

def a(x=nil, y)
end

# --

a(1, 2)

# --

def identifier(column, table=nil)
end

# --

def identifier(table=nil, column)
end

# --

def foo(bar, *)
end

# --

def foo(bar, *)
  bar = 2
  super
end

# --

def a(*bar)
end

# --

def a(bar)
end

# --

def a(bar=[])
end

# --

EMPTY_ARRAY = [].freeze
def a(bar=EMPTY_ARRAY)
end

# --

EMPTY_ARRAY = [].freeze
def a(bar=EMPTY_ARRAY)
  bar << 1
end

# --

EMPTY_ARRAY = [].freeze
def a(bar=EMPTY_ARRAY)
  bar = bar.dup
  bar << 1
end

# --

a(:foo, :bar)

# --

a([:foo, :bar])

# --

a(array)

# --

a(*array)

# --

def a(x, *y)
end

# --

def a(x, y=nil, *z)
end

# --

def a(*y, z)
end

# --

def mv(source, *sources, dir)
  sources.unshift(source)
  sources.each do |source|
    move_into(source, dir)
  end
end

# --

mv("foo", "dir")
mv("foo", "baz", "baz", "dir")

# --

# Hash
foo({:bar=>1})

# Hash (without braces)
foo(:bar=>1)

# --

def foo(options)
end

# --

def foo(options={})
end

# --

OPTIONS = {}.freeze
def foo(options=OPTIONS)
end

# --

foo(:bar=>1)

# --

BAR_OPTIONS = {:bar=>1}.freeze
foo(BAR_OPTIONS)

# --

def foo(options=OPTIONS)
  bar = options[:bar]
end

# :baz keyword ignored
foo(:baz=>2)

# --

def foo(options=OPTIONS)
  options = options.dup
  bar = options.delete(:bar)
  raise ArgumentError unless options.empty?
end

# --

def foo(bar: nil)
end

# --

# No allocations
foo
foo(bar: 1)

# This allocates a hash
hash = {bar: 1}

# But in Ruby 3, calling a method with a
# keyword splat does not
foo(**hash)

# --

foo(baz: 1)
# ArgumentError (unknown keyword: :baz)

# --

def foo(*args, **kwargs)
  [args, kwargs]
end

# Keywords treated as keywords, good!
foo(bar: 1)
# => [[], {:bar=>1}]

# Hash treated as keywords, bad!
foo({bar: 1})
# => [[], {:bar=>1}]

# --

# Keywords treated as keywords, good!
foo(bar: 1)
# => [[], {:bar=>1}]

# Hash treated as positional argument, good!
foo({bar: 1})
# => [[{:bar=>1}], {}]

# --

# Always allocates a hash
def foo(**kwargs)
end

# --

def foo(**kwargs)
  bar(**kwargs)
end

def bar(**kwargs)
  baz(**kwargs)
end

def baz(key: nil)
  key
end

# 2 hash allocations
foo

# --

def foo(options=OPTIONS)
  bar(options)
end

def bar(options=OPTIONS)
  baz(options)
end

def baz(options=OPTIONS)
  key = options[:key]
end

# 0 hash allocations
foo

# --

def foo(key: nil)
  bar(key: key)
end

def bar(key: nil)
  baz(key: key)
end

def baz(key: nil)
  key
end

# 0 hash allocations
foo

# --

def foo(bar, **nil)
end

# --

def foo(bar)
  bar
end

# --

foo(bar: 1)
# => {:bar=>1}

# --

def foo(bar, baz: nil)
  bar
end

# --

foo(bar: 1)
# ArgumentError (wrong number of arguments)

# --

def foo(bar, **nil)
  bar
end

# --

foo(bar: 1)
# ArgumentError (no keywords accepted)

# --

def foo(options=OPTIONS)
  bar(options)
  baz(options)
end

def bar(options)
  options[:bar]
end

def baz(options)
  options[:baz]
end

# --

def foo(**kwargs)
  bar(**kwargs)
  baz(**kwargs)
end

def bar(bar: nil)
  bar
end

def baz(baz: nil)
  baz
end

# --

def foo(bar: nil, baz: nil)
  bar(bar: nil)
  baz(baz: nil)
end

def bar(bar: nil)
  bar
end

def baz(baz: nil)
  baz
end

# --

def foo(**kwargs)
  bar(**kwargs)
  baz(**kwargs)
end

def bar(bar: nil, baz: nil)
  bar
end

def baz(baz: nil, bar: nil)
  baz
end

# --

def foo(**kwargs)
  bar(**kwargs)
  baz(**kwargs)
end

def bar(bar: nil, **)
  bar
end

def baz(baz: nil, **)
  baz
end

# --

# Positional
def foo(bar=nil)
end

# Keyword
def foo(bar: nil)
end

# --

# Positional
def foo(bar=nil, baz=nil)
end

# Keyword
def foo(bar: nil, baz: nil)
end

# --

# Positional
foo(nil, 1)

# Keyword
foo(baz: 1)

# --

def foo(bar)
  yield(bar, @baz)
end

# --

foo(1) do |bar, baz|
  bar + baz
end

# --

def foo(bar)
  yield(bar, @baz, @initial || 0)
end

# --

foo(1) do |bar, baz|
  bar + baz
end

# --

foo(1) do |bar, baz, initial|
  bar + baz + initial
end

# --

adder = -> (bar, baz) do
  bar + baz
end

# Worked before, now broken
foo(1, &adder)

# --

def foo(bar, include_initial: false)
  if include_initial
    yield(bar, @baz, @initial || 0)
  else
    yield(bar, @baz)
  end
end

# --

def listen
  server.start_listening
  server.receive_notification
ensure
  server.stop_listening
end

# --

notification = listen

# --

def listen
  server.start_listening
  yield
  server.receive_notification
ensure
  server.stop_listening
end

# --

time = nil
notification = listen do
  time = Time.now
end
elapsed_seconds = Time.now - time

# --

while notification = listen
  process_notification(notification)
end

# --

listen do |notification|
  process_notification(notification)
end

# --

def listen(callback: nil)
  server.start_listening
  yield
  if callback
    while notification = server.receive_notification
      callback.(notification)
    end
  else
    server.receive_notification
  end
ensure
  server.stop_listening
end

# --

listen(callback: ->(notification) do
  process_notification(notification)
end)

# --

def listen(after_listen: nil)
  server.start_listening
  after_listen.call if after_listen
  if block_given?
    while notification = server.receive_notification
      yield notification
    end
  else
    server.receive_notification
  end
ensure
  server.stop_listening
end

## Learning the importance of method visibility

class MethodVis
  protected def foo
    :foo
  end
end

MethodVis.instance_methods(false)
# => [:foo]

m = MethodVis.new
m.methods.include?(:foo)
# => true

m.foo
# NoMethodError

# --

m.foo
# NoMethodError

# --

class MethodVis
  def method_missing(sym, ...)
    if sym == :foo
      warn("foo is a protected method, stop calling it!",
           uplevel: 1)
      return foo(...)
    end
    super
  end
end

m.foo
# foo is a protected method, stop calling it!
# => :foo

# --

class ConstantVis
  PRIVATE = 1
  private_constant :PRIVATE
end

ConstantVis::PRIVATE
# NameError

# --

class ConstantVis
  def self.const_missing(const)
    if const == :PRIVATE
      warn("foo is a protected method, stop calling it!",
           uplevel: 1)
      return PRIVATE
    end
    super
  end
end

ConstantVis::PRIVATE
# ConstantVis::CONSTANT is private, stop accessing it!
# => 1

# --

require 'deprecate_public'

class MethodVis
  deprecate_public :foo
end

class ConstantVis
  deprecate_public_constant :PRIVATE
end

## Handling delegation

def foo(*args, **kwargs, &block)
  [args, kwargs, block]
end

# --

def bar(*args, **kwargs, &block)
  [args, kwargs, block]
end

# --

def foo(*args, **kwargs, &block)
  warn("foo is being renamed to bar", uplevel: 1)
  bar(*args, **kwargs, &block)
end

# --

def foo(...)
  warn("foo is being renamed to bar", uplevel: 1)
  bar(...)
end

# --

def foo(*args, &block)
  warn("foo is being renamed to bar", uplevel: 1)
  bar(*args, &block)
end

# --

def foo(*args, &block)
  warn("foo is being renamed to bar", uplevel: 1)
  bar(*args, &block)
end
ruby2_keywords(:foo) if respond_to?(:ruby2_keywords, false)

# --

class A
  attr_accessor :b

  def initialize(b)
    @b = b
  end
end

# --

class A
  def foo(*args, **kwargs, &block)
    b.foo(*args, **kwargs, &block)
  end
end

# --

class A
  def foo(...)
    b.foo(...)
  end
end

# --

class A
  def foo(*args, &block)
    b.foo(*args, &block)
  end
  if respond_to?(:ruby2_keywords, false)
    ruby2_keywords(:foo)
  end
end

# --

require 'forwardable'

class A
  extend Forwardable
  def_delegators :b, :foo
end

# --

class A
  extend Forwardable
  def_delegators :@b, :foo
  def_delegators "A::B", :foo
end

# --

class A
  extend Forwardable
  def_delegators :b, :foo, :bar, :baz
end

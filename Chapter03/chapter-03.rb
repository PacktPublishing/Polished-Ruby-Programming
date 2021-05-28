### 3
### Proper Variable Usage

## Using Ruby's favorite variable type - the local variable

time_filter = TimeFilter.new(Time.local(2020, 10),
                             Time.local(2020, 11))
array_of_times.filter!(&time_filter)

# --

after_now = TimeFilter.new(Time.now, nil)
in_future, in_past = array_of_times.partition(&after_now)

# --

class TimeFilter
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
  end

  def to_proc
    proc do |value|
      next false if start && value < start
      next false if finish && value > finish
      true
    end
  end
end

# --

def to_proc
  proc do |value|
    start = self.start
    finish = self.finish

    next false if start && value < start
    next false if finish && value > finish
    true
  end
end

# --

def to_proc
  start = self.start
  finish = self.finish

  proc do |value|
    next false if start && value < start
    next false if finish && value > finish
    true
  end
end

# --

def to_proc
  start = self.start
  finish = self.finish

  if start && finish
    proc{|value| value >= start && value <= finish}
  elsif start
    proc{|value| value >= start}
  elsif finish
    proc{|value| value <= finish}
  else
    proc{|value| true}
  end
end

# --

num_arrays = 0
large_array.each do |value|
  if value.is_a?(Array)
    num_arrays += 1
  end
end

# --

num_arrays = 0
array_class = Array
large_array.each do |value|
  if value.is_a?(array_class)
    num_arrays += 1
  end
end

# --

large_array.reject! do |value|
  value / 2.0 >= ARGV[0].to_f
end

# --

max = ARGV[0].to_f
large_array.reject! do |value|
  value / 2.0 >= max
end

# --

max = ARGV[0].to_f
large_array.reject! do |value|
  value >= max * 2
end

# --

max = ARGV[0].to_f * 2
large_array.reject! do |value|
  value >= max
end

# --

hash = some_value.to_hash
large_array.each do |value|
  hash[value] = true unless hash[:a]
end

# --

hash = some_value.to_hash
a_value = hash[:a]
large_array.each do |value|
  hash[value] = true unless a_value
end

# --

hash = some_value.to_hash
unless a_value = hash[:a]
  large_array.each do |value|
    hash[value] = true
  end
end

# --

enumerable_of_times.reject! do |time|
  time > Time.now
end

# --

now = Time.now
enumerable_of_times.reject! do |time|
  time > now
end

# --

greater_than_now = proc do |time|
  time > Time.now
end

# --

now = Time.now
greater_than_now = proc do |time|
  time > now
end

# --

defined?(a) # nil
a = 1
defined?(a) # 'local-variable'
module M
  defined?(a) # nil
  a = 2
  defined?(a) # 'local-variable'
  class C
    defined?(a) # nil
    a = 3
    defined?(a) # 'local-variable'
    def m
      defined?(a) # nil
      a = 4
      defined?(a) # 'local-variable'
    end

# --

    a # 3
  end
  a # 2
end
a # 1

# --

M::C.new.m
a # 1

# --

defined?(a) # nil
a = 1
defined?(a) # 'local-variable'
M = Module.new do
  defined?(a) # 'local-variable'
  a = 2
  self::C = Class.new do
    defined?(a) # 'local-variable'
    a = 3
    define_method(:m) do
      defined?(a) # 'local-variable'
      a = 4
    end

# --

    a # 3
  end
   a # 3
end
a # 3

# --

M::C.new.m
a # 4

# --

def multiplier
  Math::PI * ARGV[0].to_f
end

# --

multiplier = Math::PI * ARGV[0].to_f
define_method(:multiplier) do
  multiplier
end

# --

class T
  MUTEX = Mutex.new
  def safe
    MUTEX.synchronize do
      # non-thread-safe code
    end
  end
end

# --

T::MUTEX.synchronize{T.new.safe}

# --

class T
  MUTEX = Mutex.new
  private_constant :MUTEX
  def safe
    MUTEX.synchronize do
      # non-thread-safe code
    end
  end
end

# --

T.const_get(:MUTEX).synchronize{T.new.safe}

# --

class T
  mutex = Mutex.new
  define_method(:safe) do
    mutex.synchronize do
      # non-thread-safe code
    end
  end
end

# --

@albums.each do |a|
  puts a.name
end

# --

@albums.each do
  puts _1.name
end

# --

@albums.each do |album|
  puts album.name
end

# --

array.each do |a|
  puts a.name
end

# --

TransactionProcessingSystemReport.each do
  |transaction_processing_system_report|
    puts transaction_processing_system_report.name
  end

# --

TransactionProcessingSystemReport.each do |tps_report|
  puts tps_report.name
end

# --

TransactionProcessingSystemReport.each do |report|
  puts report.name
end

# --

3.times do |i|
  type = AlbumType[i]
  puts type.name
  type.albums.each do |album|
    puts album.name
  end
  puts
end

# --

options.each do |k, v|
  puts "#{k}: #{v.length}"
end

# --

options.each do |k, v|
  k.each do |k2|
    v.each do |v2|
      p [k2, v2]
    end
  end
end

# --

options.each do |key_list, value_list|
  key_list.each do |key|
    value_list.each do |value|
      p [key, value]
    end
  end
end

## Learning how best to use instance variables

a = []
b = []

# --

a = nil
b = nil

# --

LineItem = Struct.new(:name, :price, :quantity)

class Invoice
  def initialize(line_items, tax_rate)
    @line_items = line_items
    @tax_rate = tax_rate
  end

  def total_tax
    @tax_rate * @line_items.sum do |item|
      item.price * item.quantity
    end
  end
end

# --

  def total_tax
    @total_tax ||= @tax_rate * @line_items.sum do |item|
      item.price * item.quantity
    end
  end

# --

  def total_tax
    return @total_tax if defined?(@total_tax)
    @total_tax = @tax_rate * @line_items.sum do |item|
      item.price * item.quantity
    end
  end

# --

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

# --

  def total_tax
    return @cache[:total_tax] if @cache.key?(:total_tax)
    @cache[:total_tax] = @tax_rate *
      @line_items.sum do |item|
        item.price * item.quantity
      end
  end

# --

line_items = [LineItem.new('Foo', 3.5r, 10)]
invoice = Invoice.new(line_items, 0.095r)
tax_was = invoice.total_tax
line_items << LineItem.new('Bar', 4.2r, 10)
tax_is = invoice.total_tax

# --

def initialize(line_items, tax_rate)
  @line_items = line_items.dup
  @tax_rate = tax_rate
  @cache = {}
  freeze
end

# --

def initialize(line_items, tax_rate)
  @line_items = line_items.freeze
  @tax_rate = tax_rate
  @cache = {}
  freeze
end

# --

def initialize(line_items, tax_rate)
  @line_items = line_items.dup.freeze
  @tax_rate = tax_rate
  @cache = {}
  freeze
end

# --

line_items = [LineItem.new('Foo', 3.5r, 10)]
invoice = Invoice.new(line_items, 0.095r)
tax_was = invoice.total_tax
line_items.first.quantity = 100
tax_is = invoice.total_tax

# --

LineItem = Struct.new(:name, :price, :quantity) do
  def initialize(...)
    super
    freeze
  end
end

# --

def initialize(line_items, tax_rate)
  @line_items = line_items.map do |item|
    item.dup.freeze
  end.freeze
  @tax_rate = tax_rate
  @cache = {}
  freeze
end

# --

class Invoice
  def line_item_taxes
    @line_items.map do |item|
      @tax_rate * item.price * item.quantity
    end
  end
end

# --

class LineItemList < Array
  def initialize(*line_items)
    super(line_items.map do |name, price, quantity|
      LineItem.new(name, price, quantity)
    end)
  end

  def map(&block)
    super do |item|
      item.instance_eval(&block)
    end
  end
end

Invoice.new(LineItemList.new(['Foo', 3.5r, 10]), 0.095r)

# --

line_item_list.map do
  price * quantity
end

# --

line_item_list.map do |item|
  item.price * item.quantity
end

# --

class Invoice
  def line_item_taxes
    @line_items.map do |item|
      @tax_rate * item.price * item.quantity
    end
  end
end

# --

class Invoice
  def line_item_taxes
    tax_rate = @tax_rate
    @line_items.map do |item|
      tax_rate * item.price * item.quantity
    end
  end
end

# --

@transaction_processing_system_report =
  TransactionProcessingSystemReport.new

# --

@tps_report = TransactionProcessingSystemReport.new

# --

@report = TransactionProcessingSystemReport.new

## Understanding how constants are just a type of variable

A = 1
A = 2

# --

# warning: already initialized constant A
# warning: previous definition of A was here

# --

class A
  W = 0
  X = 1
  Y = 2
  Z = 3
end

class Object
  U = -1
  Y = -2
end

# --

class B < A
  X = 4
  Z = 5
end

# --

class B
  U # -1, from Object
  W # 0, from A
  X # 4, from B
  Y # 2, from A
  Z # 5, from B
end

# --

class C < A
  Y = 6
end

# --

class D
  Z = 7
end

# --

class E < D
  W = 8
end

# --

class E
  class ::C
    U # -1, from Object
    W # 8, from E
    X # 1, from A
    Y # 6, from C
    Z # 3, from A
  end
end

# --

class C
  class ::E
    U # -1, from Object
    W # 8 from E
    X # NameError
    Y # 6, from C
    Z # 7, from D
  end
end

# --

class B
  class ::C
    class ::E
      U # -1, from Object
      W # 8 from E
      X # 4, from B
      Y # 6, from C
      Z # 5, from B
    end
  end
end

# --

class C
  @a # instance variable of C
end

class B
  class ::C
    @a # same instance variable of C
  end
end

# --

class A
  X = 2
  private_constant :X
end

A::X
# NameError

# --

A::X = 3
# warning: already initialized constant A::X

# --

A::X
# NameError

# --

class A
  public_constant :X
end

A::X # 3

# --

class A
  @a = 1

  class << self
    attr_reader :a
  end
end

A.a # 1

## Replacing class variables

class A
  @@a = 1

  class << self
    @@a
  end

  def b
    @@a
  end
end

class B < A
  @@a
end

# --

class B
  @@a = 2
end

A.new.b # 2

# --

class B
  @@b = 3

  def c
    @@b
  end
end

B.new.c # 3

# --

class A
  @@b # NameError
end

# --

class A
  @@b = 4
end

# --

B.new.c
# RuntimeError (class variable @@b of B is overtaken by A)

# --

class A
  C = 1
end

class B < A
  C # 1
end

# --

class B
  C = 2
end

class B
  C # 2
end

class A
  C # 1
end

# --

class B
  C += 1 # warning
end

# --

class B
  def increment
    # would be SyntaxError, dynamic constant assignment
    # C += 1
  end
end

# --

class B
  def increment
    self.class.const_set(:C, C + 1)
  end
end

# --

class B
  C = [0]
  def increment
    C[0] += 1
  end
end

# --

class A
  @c = 1
end

class B < A
end

# --

class B
  if defined?(@c)
    c = @c
  else
    klass = self
    while klass = klass.superclass
      if klass.instance_variable_defined?(:@c)
        c = klass.instance_variable_get(:@c)
        break
      end
    end
  end
end

# --

def A.c
  if defined?(@c)
    @c
  else
    klass = self
    while klass = klass.superclass
      if klass.instance_variable_defined?(:@c)
        return klass.instance_variable_get(:@c)
      end
    end
  end
end

A.c # 1
B.c # 1

# --

class B
  @c = 2
end

A.c # 1
B.c # 2

# --

def A.c
  defined?(@c) ? @c : superclass.c
end

# --

class A
  @c = 1

  def self.inherited(subclass)
    subclass.instance_variable_set(:@c, @c)
  end
end

class B < A
  @c # 1
end

## Avoiding global variables, most of the time

$LOAD_PATH.unshift("../lib")

# --

def no_warnings
  verbose = $VERBOSE
  $VERBOSE = nil
  yield
ensure
  $VERBOSE = verbose
end

# --

$stdout.write($stdin.read) rescue $stderr.puts($!.to_s)

# --

class SomeObject
  def current_user
    $current_user
  end
end

# --

$current_user = User[user_id]

# --

$invoices_processed = 0

# --

$invoices_processed += 1
if $invoices_processed % 100 == 0
  print '.'
end

# --

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

# --

INVOICES_PROCESSED.processed

# --

class Invoice
  @number_processed = 0
  singleton_class.send(:attr_accessor, :number_processed)
end

# --

Invoice.number_processed += 1
if Invoice.number_processed % 100 == 0
  print '.'
end

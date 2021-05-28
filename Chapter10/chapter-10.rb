### 10
### Designing Useful Domain Specific Languages

## Designing your domain-specific language

RSpec.configure do |c|
  c.drb = true
  c.drb_port = 24601

  c.around do |spec|
    DB.transaction(rollback: :always, &spec)
  end
end

# --

RSpec::Core::DRbRunner.new(port: 24601)

RSpec::Core::Hooks.register(:prepend, :around) do |spec|
  DB.transaction(rollback: :always, &spec)
end

# --

module RSpec
  self.drb = true
  self.drb_port = 24601

  around do |spec|
    DB.transaction(rollback: :always, &spec)
  end
end

# --

module RSpec
  drb = true
  drb_port = 24601
end

# --

module RSpec
  set_drb true
  set_drb_port 24601
end

# --

module RSpec
  drb true       # Set the value
  drb_port 24601 # Set the value
end
RSpec.drb
# => true
RSpec.drb_port
# => 24601

# --

Foo.process_bars(
  [:bar1, :baz2, 3, {quux: 1}],
  [:bar2, :baz4, 5],
  # ...
  skip_check: ->(bar){bar.number == 5},
  generate_names: true
)

# --

bar1 = Bar.new(:bar1, :baz2, 3, quux: 1)
bar2 = Bar.new(:bar2, :baz4, 5)

command = ProcessBarCommand.new
command.add_bar(bar1)
command.add_bar(bar2)
# ...
command.skip_check{|bar| bar.number == 5}
command.generate_names = true

Foo.process_bars(command)

# --

Foo.process_bars do |c|
  c.bar(:bar1, :baz2, 3, quux: 1)
  c.bar(:bar2, :baz4, 5)
  # ...
  c.skip_check{|bar| bar.number == 5}
  c.generate_names = true
end

# --

command = ProcessBarCommand.new do |c|
  c.bar(:bar1, :baz2, 3, quux: 1)
  c.bar(:bar2, :baz4, 5)
  # ...
  c.skip_check{|bar| bar.number == 5}
  c.generate_names = true
end

Foo.process_bars(command)

# --

DB[:table].where(Sequel[:column] > 11)
# generates SQL: SELECT * FROM table WHERE (column > 11)

# --

DB[:table].where{column > 11}

# --

@some_var = 10
DB[:table].where{column > @some_var}

# --

@some_var = 10
DB[:table].where{|o| o.column > @some_var}

# --

require 'minitest/autorun'

describe Class do
  before do
    # setup code
  end

  after do
    # teardown code
  end

  it "should allow creating classes via .new" do
    Class.new.must_be_kind_of Class
  end
end

# --

require 'sinatra'

get "/" do
  "Index page"
end

not_found do
 "File Not Found"
end

## Implementing your domain-specific language

def RSpec.configure
  yield RSpec::Core::Configuration.new
end

# --

class ProcessBarDSL
  def initialize(command)
    @command = command
  end

  def bar(...)
    @command.add_bar(...)
  end

  def method_missing(...)
    @command.send(...)
  end
end

# --

def Foo.process_bars
  command = ProcessBarCommand.new
  yield ProcessBarDSL.new(command)

  handle_bar_processing(command)
end

# --

def Foo.process_bars(command=nil)
  unless command
    command = ProcessBarCommand.new
    yield ProcessBarDSL.new(command)
  end

  handle_bar_processing(command)
end

# --

def where(&block)
  cond = if block.arity == 1
    yield Sequel::VIRTUAL_ROW
  else
    Sequel::VIRTUAL_ROW.instance_exec(&block)
  end

  add_where(cond)
end

# --

Sequel::VIRTUAL_ROW = Class.new(BasicObject) do
  def method_missing(meth)
    Sequel::SQL::Identifier.new(meth)
  end
end.new

# --

module Kernel
  def describe(name, *, &block)
    klass = Class.new(Minitest::Spec)
    klass.name = name
    klass.class_eval(&block)
    klass
  end
end

# --

class Minitest::Spec
  def self.before(&block)
    define_method(:setup, &block)
  end

  def self.after(&block)
    define_method(:teardown, &block)
  end
end

# --

class Minitest::Spec
  def self.it(description, &b)
    @num_specs ||= 0
    @num_specs += 1
    define_method("test_#{@num_specs}_#{description}", &b)
  end
end

# --

module Sinatra::Delegator
  meths = %i[get not_found] # ...

  meths.each do |meth|
    define_method(meth) do |*args, &block|
      Sinatra::Application.send(meth, *args, &block)
    end
  end
end

extend Sinatra::Delegator

### Testing to Ensure Your Code Works

## Understanding why testing is so critical in Ruby

Dir['/path/to/dir/**/*.rb'].each do |file|
  print file, ': '
  system('ruby', '-c', '--disable-gems', file)
end

# --

Dir['/path/to/dir/**/*.rb'].each do |file|
  read, write = IO.pipe
  print '.'
  system('ruby', '-c', '--disable-gems', file,
         out: write, err: write)
  write.close
  output = read.read
  unless output.chomp == "Syntax OK"
    puts
    puts output
  end
end

# --

Dir['/path/to/dir/**/*.rb'].each do |file|
  read, write = IO.pipe
  print '.'
  system('ruby', '-wc', '--disable-gems', file,
         out: write, err: write)
  write.close
  output = read.read
  unless output.chomp == "Syntax OK"
    puts
    puts output.sub(/Syntax OK\Z/, '')
  end
end

## Learning different approaches to testing

bdd_specification = <<END
Feature: Check whether program finishes

  Scenario: User submits program
    Given the User submits a program with a "loop"
    When the User clicks a button to check
        whether the program will finish
    Then the system outputs whether the program will finish
END

# --

module WhichFaster
  def faster_one(callable1, callable2)
    t1 = time{callable1.call}
    t2 = time{callable2.call}
    t1 > t2 ? callable2 : callable1
  end
  private def time
    t = clock_time
    yield
    clock_time - t
  end
  private def clock_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
  extend self
end

# --

describe WhichFaster do
  it "returns faster callable" do
    which = WhichFaster.new
    c1 = which.callable1 = ->{a}
    c2 = which.callable2 = ->{b}

    which.timer = {c1=>1, c2=>2}
    _(which.faster_one).must_equal c1

    which.timer = {c1=>2, c2=>1}
    _(which.faster_one).must_equal c2
  end
end

# --

class WhichFaster
  attr_accessor :callable1, :callable2, :timer

  def faster_one
    t1 = timer[callable1]
    t2 = timer[callable2]
    t1 > t2 ? callable2 : callable1
  end
end

# --

which = WhichFaster.new
which.callable1 = callable1
which.callable2 = callable2
which.timer = ->(callable) do
  t = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  callable.call
  Process.clock_gettime(Process::CLOCK_MONOTONIC) - t
end
which.faster_one

## Considering test complexity

describe Foo do
  it "should have bar return a Bar instance" do
    Foo.new.bar.must_be_kind_of(Bar)
  end

  it "should have baz return a Baz instance" do
    Foo.new.baz.must_be_kind_of(Baz)
  end

  it "should have quux return a Quux instance" do
    Foo.new.quux.must_be_kind_of(Quux)
  end
end

# --

describe Foo do
  def method_must_return_kind_of(meth, instance)
    Foo.new.send(meth).must_be_kind_of(instance)
  end

# --

  it "should have bar return a Bar instance" do
    method_must_return_kind_of(:bar, Bar)
  end

  it "should have baz return a Baz instance" do
    method_must_return_kind_of(:baz, Baz)
  end

  it "should have quux return a Quux instance" do
    method_must_return_kind_of(:quux, Quux)
  end
end

# --

describe Foo do
  {bar: Bar, baz: Baz, quux: Quux}.each do |meth, klass|
    it "should have #{meth} return a #{klass} instance" do
      Foo.new.send(meth).must_be_kind_of(klass)
    end
  end
end

## Understanding the many levels of testing

class Foo
  singleton_class.alias_method(:build, :new)

  def build_foo(arg)
    Foo.build(arg)
  end
end

# --

describe Foo do
  it "#build_foo should call Foo.build" do
    mock = Minitest::Mock.new
    mock.expect :call, :foo, [1]

    Foo.stub :build, mock do
      _(Foo.new.build_foo(1)).must_equal :foo
    end

    mock.verify
  end
end

# --

class Foo
  def build_foo(arg)
    Foo.new(arg)
  end
end

## Realizing that 100% coverage means nothing

class Foo
  attr_accessor :bar

  def branch(v)
    v > 1 ? bar : baz
  end

  def baz; raise; end
end

# --

describe Foo do
  it "#branch should return the value of bar" do
    foo = Foo.new
    foo.bar = 3
    (foo.branch(2)).must_equal 3
  end
end

# --

describe Foo do
  it "#branch should return the value of bar" do
    Foo.new.branch(0) rescue nil
    Foo.new.branch(2) rescue nil
  end
end

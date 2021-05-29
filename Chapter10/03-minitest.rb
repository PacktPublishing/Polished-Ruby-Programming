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


module Kernel
  def describe(name, *, &block)
    klass = Class.new(Minitest::Spec)
    klass.name = name
    klass.class_eval(&block)
    klass
  end
end

class Minitest::Spec
  def self.before(&block)
    define_method(:setup, &block)
  end

  def self.after(&block)
    define_method(:teardown, &block)
  end
end

class Minitest::Spec
  def self.it(description, &b)
    @num_specs ||= 0
    @num_specs += 1
    define_method("test_#{@num_specs}_#{description}", &b)
  end
end


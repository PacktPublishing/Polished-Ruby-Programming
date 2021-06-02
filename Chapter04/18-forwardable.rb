require 'forwardable'

class A
  extend Forwardable
  def_delegators :b, :foo
end

class A
  extend Forwardable
  def_delegators :@b, :foo
  def_delegators "A::B", :foo
end

class A
  extend Forwardable
  def_delegators :b, :foo, :bar, :baz
end

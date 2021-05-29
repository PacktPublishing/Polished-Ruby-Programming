def words(&block)
  array = []

  Class.new(BasicObject) do
    define_method(:method_missing) do |meth, *|
      array << meth
    end
  end.new.instance_exec(&block)

  array.reverse
end

words{this is a list of words}
# => [:this, :is, :a, :list, :of, :words]

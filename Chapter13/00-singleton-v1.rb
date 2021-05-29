class OnlyOne
  include Singleton

  def foo
    :foo
  end
end

only1 = OnlyOne.instance
only2 = OnlyOne.instance

only1.equal?(only2)
# => true

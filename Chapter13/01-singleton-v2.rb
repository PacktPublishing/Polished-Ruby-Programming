OnlyOne = Object.new

def OnlyOne.foo
  :foo
end

Object.autoload :OnlyOne, 'only_one'

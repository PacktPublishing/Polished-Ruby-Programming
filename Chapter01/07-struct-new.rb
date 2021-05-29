def Struct.new(name, *fields)
  unless name.is_a?(String)
    fields.unshift(name)
    name = nil
  end

  subclass = Class.new(self)

  if name
    const_set(name, subclass)
  end

  # Internal magic to setup fields/storage for subclass

  def subclass.new(*values)
    obj = allocate
    obj.initialize(*values)
    obj
  end
  # Similar for allocate, [], members, inspect

  # Internal magic to setup accessor instance methods for each member

  subclass
end

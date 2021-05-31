class OpenClosed
  def self.meths(m)
    m.instance_methods + m.private_instance_methods
  end

  def self.include(*mods)
    mods.each do |mod|
      unless (meths(mod) & meths(self)).empty?
        raise "class closed for modification"
      end
    end
    super
  end

  singleton_class.alias_method :prepend, :include

  def self.extend(*mods)
    mods.each do |mod|
      unless (meths(mod) & meths(singleton_class)).empty?
        raise "class closed for modification"
      end
    end
    super
  end


  meths(self).each do |method|
    alias_name = :"__#{method}"
    alias_method alias_name, method
  end

  check_method = true
  define_singleton_method(:method_added) do |method|
    return unless check_method

    if method.start_with?('__')
      unaliased_name = method[2..-1]
      if private_method_defined?(unaliased_name) ||
             method_defined?(unaliased_name)
        check_method = false
        alias_method method, unaliased_name
        check_method = true
        raise "class closed for modification"
      end

    else
      alias_name = :"__#{method}"
      if private_method_defined?(alias_name) ||
             method_defined?(alias_name)
        check_method = false
        alias_method method, alias_name
        check_method = true
        raise "class closed for modification"
      end
    end
  end
end

OpenClosed.singleton_class.remove_method(:method_added)

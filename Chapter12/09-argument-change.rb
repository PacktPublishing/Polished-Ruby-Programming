def arg_to_be_removed(arg)
  # ...
end

def arg_to_be_removed(arg=(arg_not_given=true; nil))
  unless arg_not_given
    warn("Passing deprecated argument to #{__callee__}",
         uplevel: 1, category: :deprecated)
  end

  # ...
end

def arg_to_be_added(arg, arg2=(arg2_not_given=true; nil))
  if arg2_not_given
    warn("Should now pass 2 arguments to #{__callee__}",
         uplevel: 1, category: :deprecated)
  end

  # ...
end

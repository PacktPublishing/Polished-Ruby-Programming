def method_to_be_removed
  warn("#{__callee__} is deprecated",
       uplevel: 1, category: :deprecated)
  # ...
end

def method_to_be_removed
  warn("#{__callee__} is deprecated",
       uplevel: 1, category: :deprecated)
  _method_to_be_removed
end

private def _method_to_be_removed
  # ...
end

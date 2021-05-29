raise ArgumentError, "message"

raise ArgumentError, "message", []

# Earlier, outside the method
EMPTY_ARRAY = [].freeze

# Later, inside a method
raise ArgumentError, "message", EMPTY_ARRAY

exception = ArgumentError.new("message")
raise exception

exception = ArgumentError.new("message")
exception.set_backtrace(EMPTY_ARRAY)
raise exception

exception = ArgumentError.new("message")
if LibraryModule.skip_exception_backtraces
  exception.set_backtrace(EMPTY_ARRAY)
end
raise exception

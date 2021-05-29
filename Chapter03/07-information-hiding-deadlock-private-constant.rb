class T
  MUTEX = Mutex.new
  private_constant :MUTEX
  def safe
    MUTEX.synchronize do
      # non-thread-safe code
    end
  end
end

T.const_get(:MUTEX).synchronize{T.new.safe}

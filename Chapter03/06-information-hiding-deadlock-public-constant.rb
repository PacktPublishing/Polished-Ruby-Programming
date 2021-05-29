class T
  MUTEX = Mutex.new
  def safe
    MUTEX.synchronize do
      # non-thread-safe code
    end
  end
end

T::MUTEX.synchronize{T.new.safe}

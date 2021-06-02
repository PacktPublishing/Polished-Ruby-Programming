def listen(callback: nil)
  server.start_listening
  yield if block_given?
  if callback
    while notification = server.receive_notification
      callback.(notification)
    end
  else
    server.receive_notification
  end
ensure
  server.stop_listening
end

listen(callback: ->(notification) do
  process_notification(notification)
end)

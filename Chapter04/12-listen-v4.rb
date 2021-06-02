def listen(after_listen: nil)
  server.start_listening
  after_listen.call if after_listen
  if block_given?
    while notification = server.receive_notification
      yield notification
    end
  else
    server.receive_notification
  end
ensure
  server.stop_listening
end

listen do |notification|
  process_notification(notification)
end

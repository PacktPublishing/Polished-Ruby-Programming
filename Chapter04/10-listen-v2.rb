def listen
  server.start_listening
  yield if block_given?
  server.receive_notification
ensure
  server.stop_listening
end

time = nil
notification = listen do
  time = Time.now
end
elapsed_seconds = Time.now - time

while notification = listen
  process_notification(notification)
end

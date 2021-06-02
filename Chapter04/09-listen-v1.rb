def listen
  server.start_listening
  server.receive_notification
ensure
  server.stop_listening
end

notification = listen

require "socket"

agent_thread = Thread.new do
  server = TCPServer.new('localhost', 42624)
  client = server.accept
end
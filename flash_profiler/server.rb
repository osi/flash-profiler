require "socket"
require "flash_profiler/agent"
require "pp"

@agent = nil

def accept
  server = TCPServer.new('localhost', 42624)
  puts "waiting for connection on localhost:42624"
  @agent = Agent.new(server.accept)
end

accept

pp @agent.read_message

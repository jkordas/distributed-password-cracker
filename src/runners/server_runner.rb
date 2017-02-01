require_relative '../server'

server = Server.new

DRb.start_service(Conf::SERVER_URI, server)

puts '>> Server started successfully'

DRb.thread.join
server.stop
require_relative '../client'

DRb.start_service
server = DRbObject.new_with_uri(Conf::SERVER_URI)
client = Client.new(server)

# abxyz
client.add_task('6f7b7582570c6daeb73b452e70263fa2')

DRb.thread.join
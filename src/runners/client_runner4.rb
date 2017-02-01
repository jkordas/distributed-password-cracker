require_relative '../client'

DRb.start_service
server = DRbObject.new_with_uri(Conf::SERVER_URI)
client = Client.new(server)

# amator
client.add_task('8da583a68842ae1f547e8a028ed1f05f')

DRb.thread.join
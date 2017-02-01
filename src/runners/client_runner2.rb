require_relative '../client'

DRb.start_service
server = DRbObject.new_with_uri(Conf::SERVER_URI)
client = Client.new(server)

# baxyz
client.add_task('36affc44fad3f42a6133cb0fb9b622ba')

DRb.thread.join
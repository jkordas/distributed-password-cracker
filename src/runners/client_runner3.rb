require_relative '../client'

DRb.start_service
server = DRbObject.new_with_uri(Conf::SERVER_URI)
client = Client.new(server)

# alkfa
client.add_task('d6882ef6de3ae378d6818d7063b102e2')

DRb.thread.join
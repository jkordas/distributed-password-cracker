require_relative '../worker'

DRb.start_service
server = DRbObject.new_with_uri(Conf::SERVER_URI)
worker = Worker.new(server)
worker.start_processing
worker.stop
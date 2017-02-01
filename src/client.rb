require 'drb'
require 'carrot'
require_relative './config'

class Client
  include DRbUndumped

  def initialize(server)
    @server = server
    @client = Carrot.new(
        :host => Conf::HOST,
        :port => Conf::PORT,
        :user => Conf::USER,
        :pass => Conf::PASS
    )

    @queue = @client.queue(Conf::TASKS)

    puts ' __________________________________________ '
    puts '|                                          |'
    puts '|       Distributed Password Cracker       |'
    puts '|__________________________________________|'
    puts '|                  Client                  |'
    puts ' ------------------------------------------'
    puts ''
  end

  def add_task(hash)
    begin
      @server.add_task(self, hash)
      puts '>> Task with hash: ' + hash + ' added to server'
    rescue StandardError => e
      puts e
      stop
      exit -1
    end
  end

  def result_found(hash, result)
    puts '>> Real value of hash: ' + hash + ' is ' + result
  end

  def send_message(msg)
    puts '>> ' + msg
  end

  def stop
    @client.stop
  end
end
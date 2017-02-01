require 'carrot'
require 'drb'
require 'securerandom'
require_relative './config'
require_relative './task'
require_relative './result'
require_relative './client'
require_relative './demand'

class Server
  include DRbUndumped

  def initialize
    @demands_map = {}
    @mutex = Mutex.new

    @client = Carrot.new(
        :host => Conf::HOST,
        :port => Conf::PORT,
        :user => Conf::USER,
        :pass => Conf::PASS
    )

    @task_queue = @client.queue(Conf::TASKS)

    puts ' __________________________________________ '
    puts '|                                          |'
    puts '|       Distributed Password Cracker       |'
    puts '|__________________________________________|'
    puts '|                  Server                  |'
    puts ' ------------------------------------------ '
  end

  def add_task(client, hash)
    id = SecureRandom.hex
    pattern = Conf::PATTERN

    @mutex.synchronize do
      @demands_map[id] = Demand.new(client)
    end

    task = Task.new(id, hash, pattern)
    task_str = Marshal.dump(task)
    @task_queue.publish(task_str)

    puts '>> Task with hash: ' + task.hash + ', id: ' + task.id + ' and pattern: ' + task.pattern + ' added'
  end

  def add_result(id, hash, value)
    result = Result.new(id, hash, value)
    begin
      @mutex.synchronize do
        # handle single result
        @demands_map[result.id].result = true
        @demands_map[result.id].client.result_found(result.hash, result.result)
      end
      puts '>> Result for hash: ' + result.hash + ', id: ' + result.id + ' is: ' + result.result

    rescue NoMethodError => e
      puts '>> Client disconnected'
        puts e
    rescue Exception => e
      puts '>> Something went wrong!'
      puts e
    end
    puts '>> Result with id: ' + id + ' added'
  end

  def already_done?(task_id)
    already_done = true
    @mutex.synchronize do
      if @demands_map.key?(task_id)
        already_done = @demands_map[task_id].result
        @demands_map[task_id].counter += 1
      end
    end

    begin
      @mutex.synchronize do
        if @demands_map[task_id].counter.modulo(10) == 0 and !already_done
          @demands_map[task_id].client.send_message('Tasks already processed: ' + @demands_map[task_id].counter.to_s)
        end
      end
    rescue NoMethodError => e
      puts '>> Client disconnected'
        puts e
    rescue Exception => e
      puts '>> Something went wrong!'
      puts e
    end

    already_done
  end

  def stop
    @client.stop
  end
end

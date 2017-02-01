require 'drb'
require 'carrot'
require_relative './config'
require_relative './task'
require_relative './values_creator'
require_relative './result'

class Worker

  def initialize(server)
    @server = server
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
    puts '|                  Worker                  |'
    puts ' ------------------------------------------ '
  end

  def start_processing
    loop do
      begin
        task_str = @task_queue.pop(:ack => true)
        task = Marshal.load(task_str)
        puts '>> Task: ' + task.id + ' is processing with pattern: ' + task.pattern

        already_done = @server.already_done?(task.id)
        if !already_done
          value = task.start

          if value == $not_found
            puts '>> Not found'
            #generate next patterns
            patterns_array = task.generate_next_patterns_array
            for i in 0..patterns_array.length - 1
              publish_sub_task(task.id, task.hash, patterns_array[i])
            end
          else
            publish_result(task.id, task.hash, value)
          end
        end
        @task_queue.ack
      rescue TypeError => e
        sleep 1
      end
    end
  end

  def publish_sub_task(task_id, task_hash, task_pattern)
    task = Task.new(task_id, task_hash, task_pattern)
    task_str = Marshal.dump(task)
    @task_queue.publish(task_str)
  end

  def publish_result(task_id, task_hash, task_result)
    puts '>> Found, publishing results'
    #publish result through server
    @server.add_result(task_id, task_hash, task_result)
  end

  def stop
    @client.stop
  end
end
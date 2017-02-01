module Conf
  # rabbit mq connection setting
  PORT = 5672
  HOST = 'localhost'
  USER = 'guest'
  PASS = 'guest'

  SERVER_URI = 'druby://127.0.0.1:61677' # drb server access

  TASKS = 'tasks' #topic name

  # pattern config
  PATTERN = '***'
  MAX_LENGTH = 8
end

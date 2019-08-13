#!/usr/bin/ruby

load_paths = Dir["/opt/ruby/gems/**/**/lib"]
$LOAD_PATH.unshift(*load_paths)

require 'aws-sdk-sns'

def publish_message(msg, topic)
  puts topic.publish({
    message: msg
  })
end

sns = Aws::SNS::Resource.new(
  access_key_id: 'AKIAIOSFODNN7EXAMPLE',
  secret_access_key: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
  region: 'us-east-1',
  endpoint: 'http://localhost:9911'
)

topic = sns.topic('arn:aws:sns:us-east-1:1465414804035:test1')

f="./lorem_ipsum.txt"
lines_at_time=10

File.open(f) do |file|
  file.lazy.drop(1).each_slice(lines_at_time) do |lines|

    #N Threads, N = number of lines read
    pool = []
    lines.each do |line|
      pool << Thread.new {
        publish_message(line, topic)
      }
    end
    pool.each(&:join)

  end
end

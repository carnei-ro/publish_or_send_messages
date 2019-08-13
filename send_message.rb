#!/usr/bin/ruby

load_paths = Dir["/opt/ruby/gems/**/**/lib"]
$LOAD_PATH.unshift(*load_paths)

require 'aws-sdk-sqs'

sqs = Aws::SQS::Client.new(
  access_key_id: 'AKIAIOSFODNN7EXAMPLE',
  secret_access_key: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
  region: 'us-east-1',
  endpoint: 'http://localhost:9324'
)

queue_url='http://sqs:9324/queue/queue1'

def generate_map(array_of_messages)
  r = []
  array_of_messages.each_with_index do |m, i|
    r << {
      id: SecureRandom.uuid,
      message_body: m
    }
  end
  return r
end

def send_message_batch(sqs, queue_url, entries)
  r = sqs.send_message_batch({
    queue_url: queue_url,
    entries: entries,
  })
  puts "Successfully sent #{r[:successful].size} messages"
end


f="./lorem_ipsum.txt"
lines_at_time=100

File.open(f) do |file|
  file.lazy.drop(1).each_slice(lines_at_time) do |lines|
    
    pool = []
    lines.each_slice(10).to_a.each do |up_to_ten_lines|
      pool << Thread.new {
        msgs = generate_map(up_to_ten_lines)
        send_message_batch(sqs, queue_url, msgs)
      }
    end
    puts "Spawning #{pool.size} threads"
    pool.each(&:join)

  end
end

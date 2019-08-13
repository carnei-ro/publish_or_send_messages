## send_messages.rb  

Read the file 100 lines per time, spawn up to 10 threads to send batches up to 10 messages each to SQS

## publish_messages.rb

Read the file 10 lines per time, spawn up to 10 threads to publish 1 message each

## some commands

`bundle install --path vendor/bundle`

`echo 127.0.0.1 sqs | sudo tee -a /etc/hosts`

`aws sqs --endpoint-url http://localhost:9324 --region=us-east-1 receive-message --queue-url=http://sqs:9324/queue/queue1`

## doc

https://docs.aws.amazon.com/lambda/latest/dg/ruby-package.html

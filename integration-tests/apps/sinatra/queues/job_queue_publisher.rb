require 'org.torquebox.messaging-client'

class JobQueuePublisher
  def initialize
    @queue = TorqueBox::Messaging::Queue.new '/queues/jobs'
  end
  def run
    @queue.publish "employment!"
  end
end

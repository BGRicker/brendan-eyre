require "active_job/logging"

ActiveSupport::Notifications.unsubscribe("enqueue.active_job")

module ActiveJob
  module Logging
    class EnqueueLogSubscriber < ActiveSupport::LogSubscriber
      def enqueue(event)
        # Custom enqueue logging implementation
        info do
          job = event.payload[:job]
          "Enqueued #{job.class.name} (Job ID: #{job.job_id})"
        end
      end
    end
  end
end

ActiveJob::Logging::EnqueueLogSubscriber.attach_to(:active_job)

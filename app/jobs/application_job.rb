class ApplicationJob < ActiveJob::Base
  queue_as :default

  rescue_from ActiveJob::DeserializationError do |e|
    logger.error("ActiveJob::DeserializationError - #{e.message}")
  end
end

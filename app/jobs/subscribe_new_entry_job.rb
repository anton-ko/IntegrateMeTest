class SubscribeNewEntryJob < ActiveJob::Base
  queue_as :default

  def perform(entry)
    EmailSubscriptionHandler.new(entry.email).subscribe(
      entry.competition.mailing_list_id,
      entry.first_name,
      entry.last_name
    )
  rescue EmailSubscriptionHandler::SubscriptionError => e
    logger.info("Email subscription error: #{e.message}")
  rescue EmailSubscriptionHandler::ServiceError => e
    logger.error("Email subscription service error: #{e.message}")
    # TODO: Retry later in case the service comes back up online
  end
end

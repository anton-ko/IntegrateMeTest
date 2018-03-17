class SubscribeNewEntryJob < ApplicationJob
  def perform(entry)
    EmailSubscriptionHandler.new(entry.competition.mailing_list_id).subscribe(
      entry.email,
      entry.first_name,
      entry.last_name
    )
  rescue EmailSubscriptionHandler::SubscriptionError => e
    logger.info("Email subscription error: #{e.message}")
  rescue EmailSubscriptionHandler::ServiceError => e
    logger.error("Email subscription service error: #{e.message}")
    raise e # sidekiq will retry the job later
  end
end

class SubscribeNewEntryJob < ApplicationJob
  def perform(entry)
    MailingListService.new(entry.competition.account.mailchimp_key).subscribe(
      entry.competition.mailing_list_id,
      entry.email,
      entry.first_name,
      entry.last_name
    )
  rescue MailingListService::SubscriptionError => e
    logger.info("Email subscription error: #{e.message}")
  rescue MailingListService::ServiceError => e
    logger.error("Email subscription service error: #{e.message}")
    raise e # sidekiq will retry the job later
  end
end

class SubscribeNewEntryJob < ActiveJob::Base
  queue_as :default

  def perform(entry)
    Gibbon::Request
      .lists(entry.competition.mailing_list_id)
      .members(Digest::MD5.hexdigest(entry.email).downcase)
      .upsert(
        body: {
          email_address: entry.email,
          status: 'subscribed',
          merge_fields: { FNAME: entry.first_name, LNAME: entry.last_name }
        }
      )
  rescue Gibbon::MailChimpError => e
    logger.error "MailChimp Error: entry ##{entry.id} #{entry.email} - #{e.message}"
  end
end

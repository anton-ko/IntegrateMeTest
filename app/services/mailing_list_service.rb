class MailingListService
  def self.valid_key?(api_key)
    Gibbon::Request.new(api_key: api_key).ping.retrieve
  rescue Gibbon::MailChimpError, Gibbon::GibbonError
    return false
  end

  def initialize(api_key)
    @api_key = api_key
  end

  def lists
    Gibbon::Request.new(api_key: @api_key).lists.retrieve.body[:lists].map { |list| list_hash(list) }
  rescue Gibbon::MailChimpError, Gibbon::GibbonError
    return false
  end

  def fetch_list_info(mailing_list_id)
    list = Gibbon::Request.new(api_key: @api_key).lists(mailing_list_id).retrieve.body
    list_hash(list)
  rescue Gibbon::MailChimpError, Gibbon::GibbonError => e
    return nil
  end

  def subscribe(mailing_list_id, email, first_name, last_name)
    Gibbon::Request.new(api_key: @api_key)
      .lists(mailing_list_id)
      .members(Digest::MD5.hexdigest(email))
      .upsert(
        body: {
          email_address: email,
          status: 'subscribed',
          merge_fields: { FNAME: first_name.to_s, LNAME: last_name.to_s }
        }
      )
  rescue Gibbon::MailChimpError => e
    if e.status_code.to_s.starts_with?('4')
      raise SubscriptionError.new("MailChimp Error: #{email} - #{e.title} #{e.detail}")
    else
      raise ServiceError.new(e.message)
    end
  end

  class SubscriptionError < StandardError; end # client is responsible (fake email, banned email, etc.)
  class ServiceError < StandardError; end # service is responsible (down, crashing, etc.)

  private

  def list_hash(gibbon_list)
    {
      id: gibbon_list[:id],
      name: gibbon_list[:name],
      url: "https://#{@api_key.split('-').last}.admin.mailchimp.com/lists/members/?id=#{gibbon_list[:web_id]}"
    }
  end
end

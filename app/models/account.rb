class Account < ActiveRecord::Base
  has_many :competitions, inverse_of: :account

  # stub out user accounts and always use account with id=1 for now
  def self.find_current_account
    find_or_initialize_by(id: 1)
  end

  def mailchimp_key_obfuscated
    return if mailchimp_key.blank?
    mailchimp_key.sub(/\A.+(.{10})\Z/, "#{'*' * 27}\\1")
  end

  def valid_api_keys? # separate method rather than a validator because we don't want to make API calls all the time
    MailingListService.valid_key?(mailchimp_key)
  end
end

class Account < ActiveRecord::Base

  # stub out user's account and always use account with id=1
  def self.find_current_account
    find_or_initialize_by(id: 1)
  end

  def mailchimp_key_obfuscated
    return if mailchimp_key.blank?
    mailchimp_key.sub(/\A.+(.{10})\Z/, "#{'*' * 27}\\1")
  end
end

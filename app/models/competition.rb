class Competition < ActiveRecord::Base
  has_many :entries, inverse_of: :competition
  belongs_to :account

  validates_presence_of :name

  scope :with_entries_counts, -> {
    # consider adding entries_count field and using counter_cache instead
    select('competitions.*, COUNT(entries.id) as entries_count').joins(:entries).group('competitions.id')
  }

  def subscribes_to_mailing_list?
    account.mailchimp_key.present? && mailing_list_id.present?
  end

  # separate as we don't want to implicitly send 3rd-party API requests on save
  def validate_mailing_list
    return unless account.mailchimp_key && mailing_list_id
    list = MailingListService.new(account.mailchimp_key).fetch_list_info(mailing_list_id)
    if list
      self.mailing_list_name = list[:name]
      self.mailing_list_url = list[:url]
      return list
    end

    errors[:mailing_list_id] << :invalid
    false
  end
end

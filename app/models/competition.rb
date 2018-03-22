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
end

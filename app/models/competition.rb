class Competition < ActiveRecord::Base
  has_many :entries, inverse_of: :competition
  belongs_to :account

  validates_presence_of :name

  def subscribes_to_mailing_list?
    account.mailchimp_key.present? && mailing_list_id.present?
  end
end

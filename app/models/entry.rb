class Entry < ActiveRecord::Base
  EMAIL_REGEX = /\A[A-Z0-9._%a-z\-+]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,12}\z/

  belongs_to :competition

  before_validation :clean_email
  after_commit :subscribe

  validates_presence_of :competition
  validates_presence_of :email
  validates_format_of :email, :with => EMAIL_REGEX, allow_blank: true, allow_nil: true
  validates_presence_of :name, if: :requires_name
  validates_uniqueness_of :email, scope: :competition, message: "has already entered this competition"

  def first_name
    name.rpartition(' ').first if name
  end

  def last_name
    name.rpartition(' ').last if name
  end

  private
    def clean_email
      self.email = email.downcase.strip if email.present?
    end

    def requires_name
      competition&.requires_entry_name?
    end

    def subscribe
      SubscribeNewEntryJob.perform_later(self)
    end
end

class Competition < ActiveRecord::Base
  has_many :entries, inverse_of: :competition

  validates_presence_of :name

  # competitions are expected to have their own mailing lists, so, stubbing out this method for future use
  def mailing_list_id
    ENV['MAILING_LIST_ID']
  end
end

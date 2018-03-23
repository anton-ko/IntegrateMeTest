class AddMailingListInfoFieldsToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :mailing_list_name, :string
    add_column :competitions, :mailing_list_url, :string
  end
end

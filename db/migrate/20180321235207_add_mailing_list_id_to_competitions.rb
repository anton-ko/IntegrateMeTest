class AddMailingListIdToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :mailing_list_id, :string
  end
end

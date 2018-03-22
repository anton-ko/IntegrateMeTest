class AddAccountIdToCompetitions < ActiveRecord::Migration
  def change
    add_reference :competitions, :account, index: true, foreign_key: true

    reversible do |dir|
      # assign default account id for existing records
      dir.up { ActiveRecord::Base.connection.execute('UPDATE competitions SET account_id = 1') }
    end
  end
end

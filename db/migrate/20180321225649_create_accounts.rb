class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :mailchimp_key
    end

    reversible do |dir|
      dir.up do
        # create the default account
        ActiveRecord::Base.connection.execute('INSERT INTO accounts (id) VALUES(1)')
      end
    end
  end
end

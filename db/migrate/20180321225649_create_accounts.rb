class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :mailchimp_key
    end
  end
end

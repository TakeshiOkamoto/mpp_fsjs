class CreateFsjsJournals < ActiveRecord::Migration[6.0]
  def change
    create_table :fsjs_journals do |t|
      t.integer :yyyy, null: false
      t.integer :mm, null: false
      t.integer :dd, null: false
      t.integer :debit_account_id, null: false
      t.integer :credit_account_id, null: false
      t.integer :money, null: false
      t.string :summary, null: false

      t.timestamps
    end
    
    add_index :fsjs_journals, :yyyy, :unique  => false    
    add_index :fsjs_journals, :mm, :unique  => false    
    add_index :fsjs_journals, :dd, :unique  => false       
  end
end

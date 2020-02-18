class CreateFsjsAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :fsjs_accounts do |t|
      t.string  :name, null: false
      t.integer :types, null: false
      t.boolean :expense_flg, null: false
      t.integer :sort_list, null: false
      t.integer :sort_expense, null: false

      t.timestamps
    end
    
    add_index :fsjs_accounts, :name, :unique  => true    
    add_index :fsjs_accounts, :types, :unique  => false    
    add_index :fsjs_accounts, :expense_flg, :unique  => false                
  end
end

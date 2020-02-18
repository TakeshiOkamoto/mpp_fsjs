class CreateFsjsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :fsjs_users do |t|
      t.string :name
      t.string :password_digest
      t.boolean :admin

      t.timestamps
    end
    
    add_index :fsjs_users, :name, :unique  => true        
  end
end

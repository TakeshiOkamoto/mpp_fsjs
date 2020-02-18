class CreateFsjsCapitals < ActiveRecord::Migration[6.0]
  def change
    create_table :fsjs_capitals do |t|
      t.integer :yyyy, null: false
      t.integer :m1, null: false
      t.integer :m2, null: false
      t.integer :m3, null: false
      t.integer :m4, null: false

      t.timestamps
    end
    
    add_index :fsjs_capitals, :yyyy, :unique  => true       
  end
end

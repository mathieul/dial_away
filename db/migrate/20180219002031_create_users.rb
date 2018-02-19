class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email,        null: false
      t.string :name,         null: false
      t.string :country_code, null: false, default: '1'
      t.string :phone_number, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end

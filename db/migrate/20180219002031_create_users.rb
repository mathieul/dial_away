class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string  :email,            null: false
      t.string  :name,             null: false
      t.string  :password_digest,  null: false
      t.string  :country_code,     null: false, default: '1'
      t.string  :phone_number,     null: false
      t.string  :authy_id
      t.boolean :verified,         default: false

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :authy_id, unique: true
  end
end

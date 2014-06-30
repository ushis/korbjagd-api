class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :username,        null: false
      t.index   :username,        unique: true
      t.string  :email,           null: false
      t.index   :email,           unique: true
      t.string  :password_digest, null: false
      t.boolean :admin,           null: false, default: false
      t.integer :baskets_count,   null: false, default: 0
      t.timestamps
    end
  end
end

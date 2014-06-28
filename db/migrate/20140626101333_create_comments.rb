class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user,    null: false, index: true
      t.references :basket,  null: false, index: true
      t.text       :comment, null: false
      t.timestamps
    end
  end
end

class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.integer :baskets_count, null: false, default: 0
      t.timestamps
    end

    add_reference :baskets, :sector, index: true

    reversible do |dir|
      dir.up do
        Basket.all.each { |b| b.valid?; b.save }
      end
    end
  end
end

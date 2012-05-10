class CreateStockTtmInfos < ActiveRecord::Migration
  def self.up
    create_table :stock_ttm_infos do |t|
      t.integer :stock_id
      t.integer :share
      t.decimal :profit,:precision=>10, :scale=>4
      t.decimal :price, :precision=>8,:scale=>2
      t.date :day

      t.timestamps
    end
  end

  def self.down
    drop_table :stock_ttm_infos
  end
end

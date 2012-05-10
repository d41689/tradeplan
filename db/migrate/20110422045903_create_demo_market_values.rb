class CreateDemoMarketValues < ActiveRecord::Migration
  def self.up
    create_table :demo_market_values do |t|
      t.date :day, :null => false
      t.decimal :total, :precision => 16, :scale => 2, :null => false
      t.decimal :mkt_index, :precision => 8, :scale => 2, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :demo_market_values
  end
end

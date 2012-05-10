class CreateDemoTradeRecords < ActiveRecord::Migration
  def self.up
    create_table :demo_trade_records do |t|
      t.date :trade_date, :null => false
      t.string :code, :limit => 6, :null => false
      t.string :operation, :limit => 4, :null => false
      t.float :price, :null => false
      t.integer :quantity, :null => false
      t.decimal :profit
      t.decimal :profit_rate

      t.timestamps
    end
  end

  def self.down
    drop_table :demo_trade_records
  end
end

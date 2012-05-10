class CreateStockSignals < ActiveRecord::Migration
  def self.up
    create_table :stock_signals do |t|
      t.string :code, :limit => 6, :null => false
      t.integer :signal_type, :null => false
      t.integer :operation, :null => false
      t.float :buy_price, :null => false
      t.float :initial_stop_price, :null => false
      t.float :stop_price, :null => false
      t.float :his_performance, :null => false
      t.integer :long_trend, :null => false
      t.integer :mid_trend, :null => false
      t.integer :short_trend, :null => false
      t.integer :mkt_long_trend, :null => false
      t.integer :mkt_mid_trend, :null => false
      t.date :buy_date, :null => false
      t.date :sell_date, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :stock_signals
  end
end

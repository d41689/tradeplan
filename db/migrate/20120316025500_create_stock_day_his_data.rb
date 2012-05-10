class CreateStockDayHisData < ActiveRecord::Migration
  def self.up
    create_table :stock_day_his_data do |t|
      t.integer :stock_id, :null =>false
      t.date :day, :null => false
      t.decimal :open, :precision => 10, :scale => 4, :null => false
      t.decimal :high, :precision => 10, :scale => 4, :null => false
      t.decimal :low, :precision => 10, :scale => 4, :null => false
      t.decimal :close, :precision => 10, :scale => 4, :null => false
      t.decimal :amount, :precision => 16, :scale => 2 , :null => false
      t.integer :volume, :null => false
    end
    add_index(:stock_day_his_data,:stock_id,{:name=> 'day_stock_id_index', :order => {:day=>:asc}})
  end

  def self.down
    remove_index(:stock_day_his_data,:name=>'day_stock_id_index')
    drop_table :stock_day_his_data
  end
end

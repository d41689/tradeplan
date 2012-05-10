class ChangeNameOfStockCategory < ActiveRecord::Migration
  def self.up
    change_column :stock_categories,:name,:string, :limit=>48,:null => false
  end

  def self.down
    change_column :stock_categories,:name,:string, :limit=>10,:null => false
  end
end

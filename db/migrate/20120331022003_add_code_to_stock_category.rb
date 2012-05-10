class AddCodeToStockCategory < ActiveRecord::Migration
  def self.up
    add_column :stock_categories, :code, :string, :limit=>6

  end

  def self.down
    remove_column :stock_categories, :code
  end
end

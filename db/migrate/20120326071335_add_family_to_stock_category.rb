class AddFamilyToStockCategory < ActiveRecord::Migration
  def self.up
    add_column :stock_categories, :family, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :stock_categories, :family
  end
end

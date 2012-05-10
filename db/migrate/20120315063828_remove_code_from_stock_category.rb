class RemoveCodeFromStockCategory < ActiveRecord::Migration
  def self.up
    remove_columns :stock_categories, :market,:code
  end

  def self.down
    add_column :stock_categories, :market, :integer
    add_column :stock_categories, :code, :string, :null => false, :limit => 10
  end
end

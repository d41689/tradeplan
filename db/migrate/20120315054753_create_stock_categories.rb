class CreateStockCategories < ActiveRecord::Migration
  def self.up
    create_table :stock_categories do |t|
      t.integer :market
      t.string :code, :limit => 6
      t.string :name, :limit => 10, :null =>false
      #t.integer :category

      t.timestamps
    end
  end

  def self.down
    drop_table :stock_categories
  end
end

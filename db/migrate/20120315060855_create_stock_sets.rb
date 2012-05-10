class CreateStockSets < ActiveRecord::Migration
  def self.up
    create_table :stock_sets do |t|
      t.integer :stock_category_id
      t.integer :stock_id

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE stock_sets
        ADD CONSTRAINT fk_stock_categories
        FOREIGN KEY (stock_category_id)
        REFERENCES stock_categories(id)
    SQL

     execute <<-SQL
      ALTER TABLE stock_sets
        ADD CONSTRAINT fk_stocks
        FOREIGN KEY (stock_id)
        REFERENCES stocks(id)
    SQL
  end

  def self.down
    execute <<-SQL
      ALTER TABLE stock_sets
        DROP FOREIGN KEY fk_stocks
    SQL
    execute <<-SQL
      ALTER TABLE stock_sets
        DROP FOREIGN KEY fk_stock_categories
    SQL
    drop_table :stock_sets
  end
end

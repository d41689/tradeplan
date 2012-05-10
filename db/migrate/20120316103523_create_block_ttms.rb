class CreateBlockTtms < ActiveRecord::Migration
  def self.up
    create_table :block_ttms do |t|
      t.integer :stock_category_id,:null => false
      t.date :day,:null =>false
      t.decimal :ttm,:precision=>8, :scale=>2, :null =>false
      t.boolean :complete, :default =>false

      #t.timestamps
    end
  end

  def self.down
    drop_table :block_ttms
  end
end

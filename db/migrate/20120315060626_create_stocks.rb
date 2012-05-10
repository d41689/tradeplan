class CreateStocks < ActiveRecord::Migration
  def self.up
    create_table :stocks do |t|
      t.integer :market
      t.string :code, :limit=>6
      t.string :name, :limit=>8

      t.timestamps
    end
  end

  def self.down
    drop_table :stocks
  end
end

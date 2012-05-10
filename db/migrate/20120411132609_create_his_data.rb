class CreateHisData < ActiveRecord::Migration
  def self.up
    create_table :his_data do |t|
      t.integer :stock_id,:null=>false
      t.binary :day_data
      t.integer :day_number
      t.binary :week_data
      t.integer :week_number
      t.binary :month_data
      t.integer :month_number
      t.binary :hour_data
      t.integer :hour_number

      #t.timestamps
    end
  end

  def self.down
    drop_table :his_data
  end
end

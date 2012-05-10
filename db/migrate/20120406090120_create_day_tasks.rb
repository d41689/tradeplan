class CreateDayTasks < ActiveRecord::Migration
  def self.up
    create_table :day_tasks do |t|
      t.date :day, :null => false
      t.integer :windin, :default=>0
      t.integer :csindex, :default=>0
      t.integer :cninfo, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :day_tasks
  end
end

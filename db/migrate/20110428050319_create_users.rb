class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :invite_num, :null => false, :default => 0
      t.boolean :is_first_visit_today, :null => false, :default => true
      t.string :networkUid, :limit => 50, :null => false
      t.integer :network, :null => false
      t.boolean :sex, :null => false
      t.integer :experience, :null => false
      t.string :first_name, :limit => 20, :null => false
      t.string :full_name, :limit => 20, :null => false
      t.string :imageUrl, :limit => 255, :null => true, :default => nil
      t.string :largeImageUrl, :limit => 255, :null => true, :default => nil
      t.boolean :hasProfileBoxImage, :null => false
      t.string :profileUrl, :limit => 1, :null => false
      t.boolean :appInstalled, :null => false
      t.integer :credit, :null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

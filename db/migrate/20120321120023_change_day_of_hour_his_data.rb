class ChangeDayOfHourHisData < ActiveRecord::Migration
  def self.up
    change_column :stock_hour_his_data,:day,:datetime
  end

  def self.down
    change_column :stock_hour_his_data,:day,:date
  end
end

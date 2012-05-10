class ChangeShareOfStockTtmInfo < ActiveRecord::Migration
  def self.up
    change_column(:stock_ttm_infos,:share,:decimal,:precision => 16,:scale => 2)
  end

  def self.down
    change_column(:stock_ttm_infos,:share,:integer)
  end
end

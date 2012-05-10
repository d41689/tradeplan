class AddSttmToBlockTtm < ActiveRecord::Migration
  def self.up
    add_column :block_ttms, :sttm, :decimal,:precision => 8,:scale => 2
    add_column :block_ttms, :wmrq, :decimal,:precision => 8,:scale => 2
    add_column :block_ttms, :smrq, :decimal,:precision => 8,:scale => 2
    add_column :block_ttms, :sjzcsyl_ttm, :decimal,:precision => 8,:scale => 2
    add_column :block_ttms, :smll_ttm, :decimal,:precision => 8,:scale => 2
    add_column :block_ttms, :wjzcsyl_ttm, :decimal,:precision => 8,:scale => 2
    add_column :block_ttms, :wmll_ttm, :decimal,:precision => 8,:scale => 2
  end

  def self.down
    remove_column :block_ttms, :wmll_ttm
    remove_column :block_ttms, :wjzcsyl_ttm
    remove_column :block_ttms, :smll_ttm
    remove_column :block_ttms, :sjzcsyl_ttm
    remove_column :block_ttms, :smrq
    remove_column :block_ttms, :wmrq
    remove_column :block_ttms, :sttm
  end
end

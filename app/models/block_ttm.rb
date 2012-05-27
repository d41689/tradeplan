class BlockTtm < ActiveRecord::Base
  belongs_to :stock_category
end

=begin
create_table "block_ttms", :force => true do |t|
    t.integer "stock_category_id",                                                  :null => false
    t.date    "day",                                                                :null => false
    t.decimal "ttm",               :precision => 8, :scale => 2,                    :null => false
    t.boolean "complete",                                        :default => false
    t.decimal "sttm",              :precision => 8, :scale => 2
    t.decimal "wmrq",              :precision => 8, :scale => 2
    t.decimal "smrq",              :precision => 8, :scale => 2
    t.decimal "sjzcsyl_ttm",       :precision => 8, :scale => 2
    t.decimal "smll_ttm",          :precision => 8, :scale => 2
    t.decimal "wjzcsyl_ttm",       :precision => 8, :scale => 2
    t.decimal "wmll_ttm",          :precision => 8, :scale => 2
  end
=end

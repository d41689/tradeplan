class StockCategory < ActiveRecord::Base
  has_many :stock_sets, :dependent => :destroy
  has_one :block_ttm
end

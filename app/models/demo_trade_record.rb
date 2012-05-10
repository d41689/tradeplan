class DemoTradeRecord < ActiveRecord::Base
  validates :trade_date, :operation, :code, :quantity, :price, :presence => true

end

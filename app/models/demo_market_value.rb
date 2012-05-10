class DemoMarketValue < ActiveRecord::Base
  validates :day, :total, :mkt_index, :presence => true
  validates :total, :mkt_index , :numericality => {:greater_than_or_equal_to => 0.01}
  #validates :mkt_index, :presence => true
end

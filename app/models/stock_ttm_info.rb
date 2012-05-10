require 'windin_client'

class StockTtmInfo < ActiveRecord::Base
  belongs_to :stock

  def self.prepare #在prepare函数中填充从网上获取的数据
    windClient = WindinClient.new
    #stocks =  StockCategory.find_by_name("深沪A股").stock_sets.map {|x| x.stock_id}
    stocks =  StockCategory.find(92).stock_sets.map {|x| x.stock_id}

    existed_ids = StockTtmInfo.find_all_by_day( StockTtmInfo.order("id desc").limit(1).first.day ).map {|t| t.stock_id}
    stocks = stocks - existed_ids

#=begin
    until stocks.empty?
      stock = Stock.find(stocks[0])
      windClient.fetch_page(stock.market, stock.code,stocks) if stock.is_stock?
    end
#=end
  end
end

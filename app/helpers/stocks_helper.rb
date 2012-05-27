module StocksHelper
  def stock_id_to_code(stock_id)
    a_stock = Stock.find(stock_id)
    if a_stock
      a_stock.code
    else
      nil
    end
  end
end

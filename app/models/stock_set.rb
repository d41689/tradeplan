class StockSet < ActiveRecord::Base
  belongs_to :stock
  belongs_to :stock_category

=begin
  def ==(o)
    puts 'in == *****************************************'
    return nil unless o.instance_of? StockSet
    stock_id == o.stock_id && stock_category_id == o.stock_category_id
  end

  def equal?(o)
    self == o
  end

  def <=>(o)
    puts 'in <=> *****************************************'
    return nil unless o.instance_of? StockSet
    ret = stock_category <=> o.stock_category
    ret != 0 ? ret : stock_id <=> o.stock_id
  end
=end
end

class Stock < ActiveRecord::Base
  has_many :stock_sets
  has_many :stock_ttm_infos
  has_many :stock_hour_his_datas
  has_many :stock_day_his_datas
  has_many :stock_week_his_datas
  has_many :stock_month_his_datas

=begin
  def ==(o)
    return nil unless o.instance_of? Stock
    self.code == o.code
  end

  def <=>(o)
    return nil unless o.instance_of? Stock
    self.code<=>o.code
  end
=end
  def is_stock?
    if(market == 1 && /^6\d{5}$/===code)
      true
    elsif (market == 0 && (/^0\d{5}$/===code  || /^30\d{4}$/===code) )
      true
    else
      false
    end
  end
end

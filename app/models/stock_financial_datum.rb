class StockFinancialDatum < ActiveRecord::Base
=begin
    t.decimal "zsz",        :precision => 16, :scale => 4
    t.decimal "ltsz",       :precision => 16, :scale => 4
    t.decimal "ltgb",       :precision => 16, :scale => 4
    t.decimal "zgb",        :precision => 16, :scale => 4
    t.decimal "zysr_ttm",   :precision => 16, :scale => 4
    t.decimal "price",      :precision => 10, :scale => 2
    t.decimal "pe_ttm",     :precision => 10, :scale => 2

    t.decimal "pe_d",       :precision => 10, :scale => 2
    t.decimal "mrq",        :precision => 10, :scale => 2
    t.decimal "mrr",        :precision => 10, :scale => 2
    t.decimal "profit_ttm", :precision => 10, :scale => 4
    t.decimal "mgjzc",      :precision => 10, :scale => 2
    t.decimal "jzcsyl_ttm", :precision => 8,  :scale => 2
    t.decimal "mll_ttm",    :precision => 8,  :scale => 2
=end
  def has_nil_field?
    zsz.nil? || zgb.nil? || zysr_ttm.nil? || pe_ttm.nil? || mrq.nil? ||  profit_ttm.nil? || mgjzc.nil? || jzcsyl_ttm.nil? || mll_ttm.nil?
  end
end

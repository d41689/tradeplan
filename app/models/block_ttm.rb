class BlockTtm < ActiveRecord::Base
  belongs_to :stock_category
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
  def self.prepare
    puts 'in prepare....'
    the_calculated_day = BlockTtm.order("id desc").first.day
    puts "the_calculated_day:#{the_calculated_day},#{the_calculated_day.class}"
    StockCategory.all.each do |stock_category|
      puts "stock_category:#{stock_category.id},#{stock_category.name}"

      the_newest_financial_data = StockFinancialDatum.order("id desc").first
      all_days = StockFinancialDatum.where(["stock_id = ? and day >= ?", the_newest_financial_data.stock_id, the_calculated_day]).all

      a_stocks_sets = stock_category.stock_sets
      #处理某天的数据
      all_days.each do |the_day|
        puts "processing category:#{stock_category.id}, day:#{the_day.day}..."
        a_block_ttm = BlockTtm.find_by_stock_category_id_and_day(stock_category.id,the_day.day)
        next if a_block_ttm
        a_block_ttm = BlockTtm.new
        a_block_ttm.day = the_day.day
        total_capital = 0
        total_profit = 0
        total_jzc = 0
        total_zysr = 0
        total_zylr = 0

        total_ttm = 0
        total_ttm_counter = 0
        total_mrq = 0
        total_mrq_counter = 0
        total_jzcsyl = 0
        total_jzcsyl_counter = 0
        total_mll = 0
        total_mll_counter = 0
        a_stocks_sets.each do |stock|
          the_stock = Stock.find(stock.stock_id)
          next if the_stock.nil?
          next unless the_stock.is_stock?
          stock_financial_data = StockFinancialDatum.find_by_stock_id_and_day(stock.stock_id, a_block_ttm.day) #.order("id desc").first #.each do |stock_financial_data|
          unless stock_financial_data.nil?
            next if stock_financial_data.has_nil_field?
            total_capital += stock_financial_data.zsz unless stock_financial_data.zsz.nil?
            total_profit += stock_financial_data.profit_ttm * stock_financial_data.zgb
            total_jzc += stock_financial_data.mgjzc * stock_financial_data.zgb
            total_zysr += stock_financial_data.zysr_ttm unless stock_financial_data.zysr_ttm.nil?
            total_zylr += stock_financial_data.zysr_ttm * stock_financial_data.mll_ttm unless stock_financial_data.zysr_ttm.nil? || stock_financial_data.mll_ttm.nil?
            unless stock_financial_data.pe_ttm.nil?
              total_ttm += stock_financial_data.pe_ttm
              total_ttm_counter += 1
            end
            unless stock_financial_data.mrq.nil?
              total_mrq += stock_financial_data.mrq
              total_mrq_counter += 1
            end
            unless stock_financial_data.jzcsyl_ttm.nil?
              total_jzcsyl += stock_financial_data.jzcsyl_ttm
              total_jzcsyl_counter += 1
            end

            unless stock_financial_data.mll_ttm.nil?
              total_mll += stock_financial_data.mll_ttm
              total_mll_counter += 1
            end
          end
        end
        begin
          if total_profit != 0
            a_block_ttm.stock_category_id = stock_category.id

            a_block_ttm.ttm = total_capital / total_profit
            a_block_ttm.sttm = total_ttm / total_ttm_counter
            a_block_ttm.wmrq = total_capital / total_jzc
            a_block_ttm.smrq = total_mrq / total_mrq_counter
            a_block_ttm.sjzcsyl_ttm = total_jzcsyl / total_jzcsyl_counter
            a_block_ttm.wjzcsyl_ttm = total_profit / total_jzc
            a_block_ttm.wmll_ttm = total_zylr / total_zysr
            a_block_ttm.smll_ttm = total_mll / total_mll_counter
            a_block_ttm.save
          end
        rescue Exception => e
          puts e.message
        end
      end
    end
  end
end

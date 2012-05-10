# coding : utf-8

require 'open-uri'
require 'net/http'
require 'uri'
#require 'win32ole'
require 'win32ole'
class WindinClient
  SZ = 'SZ'
  SH = 'SH'
  attr_reader :array_data, :current_day

  def initialize()
    @array_data = []
    @current_day = nil
    @code_stock_id_map = {}
    puts 'in WindinClient #@code_stock_id_map'
  end

  def get_url(market, code)
    if market == 1
      "http://www.windin.com/home/stock/industry/#{code}.SH.shtml"
    elsif market == 0
      "http://www.windin.com/home/stock/industry/#{code}.SZ.shtml"
    else
      nil
    end
  end

  def fetch_data(market, code)
    url = get_url(market, code)
    begin
      open(url) { |f|
        content = f.read
        start_index = content.index('arrayData')
        if start_index.nil?
          puts "the related data not exist. this stock(#{market},#{code}) should deleted."
          return nil
        end
        start_index = content.index('[[[', start_index)
        end_index = content.index(']]]', start_index) + 3
        script_text = "@array_data = #{format_data(content[start_index, end_index-start_index])}"
        eval(script_text)
        #puts 'array_data is ok.'
        #puts @array_data
        start_index = content.index('tradeSortCurrentDay')

        if start_index.nil?
          puts "array data is exist,but currentDay not exist.,this stock(#{market},#{code}) should deleted."
          return nil
        end
        #puts 'setp 1'
        start_index = content.index('"', start_index) + 1
        end_index = content.index('"', start_index)
        #puts 'step 2'
        script_text = "@current_day = Date.parse('#{content[start_index, end_index-start_index]}')"
        #puts script_text
        eval(script_text)
        #puts @current_day
        return true
      }
    rescue TypeError => e
      puts '==================Error,shoud not display this message================'
      puts e.class
      puts e.message
      puts "the related data not exist. this stock(#{market},#{code}) should deleted."
      return nil
        #stocks.delete_at(0)
    rescue Exception => e
      puts e.message
      puts e.class
      #stocks<<stocks.delete_at(0)
      #@array_data
      puts "maybe network error, should move stock(#{market},#{code}) to the rear."
      return false
    end
  end

  def fill_stock_financial_data_table
    #wind_client = WindinClient.new
    #stocks =  StockCategory.find_by_name("深沪A股").stock_sets.map {|x| x.stock_id}
    stocks = StockCategory.find(92).stock_sets.map { |x| x.stock_id }
    exclude_flag = false


#=begin
    until stocks.empty?
      stock = Stock.find(stocks[0])
      fetch_ret = fetch_data(stock.market, stock.code) if stock.is_stock?


      if (fetch_ret)
        if (false == exclude_flag)
          exclude_flag = true
          existed_ids = StockFinancialDatum.find_all_by_day(@current_day).map { |t| t.stock_id }
          stocks = stocks - existed_ids
        end
        puts "#{stocks.size} stocks need fetch."
        #stock_financial_data = nil
        stock_hash = {}
        #涨幅数据

=begin
        puts 'begin print array_data'
        puts @array_data
        puts "array_size:#{@array_data.size}"
        puts '@array_data is nil' if @array_data.nil?
        puts '@array_data[0] is nil' if@array_data[0].nil?
        puts '@array_data[1] is nil' if@array_data[1].nil?
        puts 'array data print over.'
=end
        @array_data[0].each do |x|
          stock_code = x[-1][0, 6]
          market_code = x[-1][-2, 2] == SH ? 1 : 0
          stock = Stock.find_by_market_and_code(market_code, stock_code)

          if stock.nil?
            puts "stock(#{market_code},#{stock_code}) not exist. "
          else
            if stocks.include?(stock.id)
              #puts "stock(#{market_code},#{stock_code}) is processing."
              stock_financial_data = StockFinancialDatum.new
              stock_hash[x[-1]] = stock_financial_data

              stock_financial_data.u5 = x[1]
              stock_financial_data.u30 = x[2]
              stock_financial_data.u90 = x[3]
              stock_financial_data.u180 = x[4]
              stock_financial_data.u360 = x[5]
              stock_financial_data.stock_id = stock.id
              stock_financial_data.day = @current_day
            end
          end
        end

        @array_data[1].each do |x|
          a_stock_financial_data = stock_hash[x[-1]]
          unless (a_stock_financial_data.nil?)
            a_stock_financial_data.zsz = x[2]
            a_stock_financial_data.ltsz = x[1]
            a_stock_financial_data.ltgb = x[3]
            a_stock_financial_data.zgb = x[4]
            a_stock_financial_data.zysr_ttm = x[5]
          end
        end

        @array_data[2].each do |x|
          a_stock_financial_data = stock_hash[x[-1]]
          unless (a_stock_financial_data.nil?)
            a_stock_financial_data.price = x[1]
            a_stock_financial_data.pe_ttm = x[2]
            a_stock_financial_data.pe_d = x[3]
            a_stock_financial_data.mrq = x[4]
            a_stock_financial_data.mrr = x[5]
          end
        end


        @array_data[3].each do |x|
          a_stock_financial_data = stock_hash[x[-1]]
          unless (a_stock_financial_data.nil?)
            a_stock_financial_data.profit_ttm = x[1]
            a_stock_financial_data.mgjzc = x[2]
            a_stock_financial_data.jzcsyl_ttm = x[3]
            a_stock_financial_data.mll_ttm = x[4]
          end
        end
        stock_hash.each_value do |x|
          x.save
          stocks.delete(x.stock_id)
        end
      else
        #fetch data failed
        if fetch_ret.nil?
          stocks.delete(stock.id)
          puts "stock(#{stock.market},#{stock.code}) financial data not exist."
        else #false
             # move this stock to rear
          stocks<<stocks.delete(stock.id)
        end
      end
      ###
    end
    #=end
  end

  #传入一个股票信息，windin会查到所属类所有股票的信息，为了避免
  #多次读取网络信息，故一次性处理好该类所有的数据，并返回已处理
  #股票的stock_id集合


  def fetch_page(market, code, stocks)
    url = get_url(market, code)
    puts "-----------------------url begin--------------------------------------"
    puts 'url is nil' if url.nil?
    puts url unless url.nil?

    begin
      open(url) { |f|
        content = f.read
        start_index = content.index('arrayData')
        if start_index.nil?
          puts 'the related data not exist. this stock(#{market_code},#{stock_code}) should deleted.'
          stocks.delete_at(0)
          return
        end
        start_index = content.index('[[[', start_index)
        end_index = content.index(']]]', start_index) + 3
        #puts content[start_index, end_index-start_index].gsub(',,',',nil,')
        #puts 'return:',format_data(content[start_index, end_index-start_index])
        eval("@array_data = #{format_data(content[start_index, end_index-start_index])}")
        #puts 'step 1'
        @array_data[3].each do |x|
          stock_code = x[-1][0, 6]
          market_code = x[-1][-2, 2] == SH ? 1 : 0
          puts 'step 2'
          stock = Stock.find_by_market_and_code(market_code, stock_code)
          if stock.nil?
            puts "stock(#{market_code},#{stock_code}) not exist. "
          else
            if stocks.include?(stock.id)
              puts "stock(#{market_code},#{stock_code}) is processing."
              quote_of_the_last_day = StockDayHisData.find_last_by_stock_id(stock.id)
              ttm = StockTtmInfo.new
              ttm.day = quote_of_the_last_day.day
              ttm.price = quote_of_the_last_day.close
              ttm.share = stock.zgb
              ttm.profit = x[1]
              ttm.stock_id = stock.id
              ttm.save
              stocks.delete(stock.id)
            end
          end

        end
      }
    rescue TypeError => e
      puts '==================Error,shoud not display this message================'
      puts e.class
      puts e.message
      puts 'the related data not exist. this stock(#{market_code},#{stock_code}) should deleted.'
      stocks.delete_at(0)
    rescue Exception => e
      puts e.message
      puts e.class
      stocks<<stocks.delete_at(0)
      nil
    end
  end

  def format_data(data)
    while (data.index(',,'))
      data.gsub!(',,', ',nil,')
      #@count += 1
    end
    data
  end
end

#上证新兴指数
class SZXXClient

  def update_sample_stocks_to_db(stock_codes)
    the_stock_category = StockCategory.find_by_family_and_code(1, '000067')
    if the_stock_category.nil?
      the_stock_category = StockCategory.new
      the_stock_category.name='szxxcyzs'
      the_stock_category.family = 1
      the_stock_category.code = '000067'
      the_stock_category.save!
    end
    stock_sets = []
    stock_codes.each do |stock_code|
      a_stock_set = StockSet.new
      a_stock_set.stock_category_id = the_stock_category.id
      a_stock_set.stock_id = Stock.find_by_market_and_code(1, stock_code).id

      unless StockSet.find_by_stock_category_id_and_stock_id(a_stock_set.stock_category_id, a_stock_set.stock_id)
        a_stock_set.save!
        stock_sets << a_stock_set.id

        puts "#{stock_code} is NOT exist..."
      else
        puts "#{stock_code} is exist..."
      end
      puts "#{a_stock_set.id}:#{a_stock_set.stock_category_id},#{a_stock_set.stock_id}"
    end
    puts stock_sets
    puts 'stock_sets processed...'
    exist_ids = the_stock_category.stock_sets.map { |x| x.id }
    exist_ids = exist_ids - stock_sets
    unless exist_ids.empty?
      StockSet.delete(exist_ids)
    end
  end

  def fetch_data_from_txt_file
    file = File.open('test.txt')
    stock_codes = []
    file.each do |line|
      if /^\|6\d{5}/ === line
        stock_codes << line[1, 7] if line[1, 7] =~ /^|6\d{5}$/
      end
    end
    file.close
    update_sample_stocks_to_db(stock_codes)
    puts stock_codes
  end

  def fetch_data_from_network
    puts 'in process...'
    url = 'http://www.sse.com.cn/sseportal/index/cn/i000067/const_list.shtml'
    dest_str = 'COMPANY_CODE='
    stock_code_len = 6
    stock_codes = []
    begin
      open(url) { |f|
        content = f.read
        start_index = 0
        while start_index = content.index(dest_str, start_index)
          stock_code = content[start_index+dest_str.length, start_index+dest_str.length+stock_code_len]
          stock_codes << stock_code
          puts stock_code
          start_index = start_index+dest_str.length+stock_code_len
        end
      }
      #puts stock_codes
      update_sample_stocks_to_db(stock_codes)
    rescue TypeError => e
      puts '==================Error,shoud not display this message================'
      puts e.class
      puts e.message
      puts "the related data not exist. "
      return nil
        #stocks.delete_at(0)
    rescue Exception => e
      puts e.message
      puts e.class
      #stocks<<stocks.delete_at(0)
      #@array_data
      puts "maybe network error"
      return false
    end
  end

  def process_zjhbk
    puts 'begin process csrcindustry...'

    url = URI.parse('http://www.csindex.com.cn/')
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.get("/sseportal/ps/zhs/hqjt/csi/csrcindustry.xls")
    }
    filename='csrcindustry.xls'
    puts "get #{filename} from net ok."
    File.new(filename, "wb+") #unless File.exist?(filename)
    f = File.open(filename, 'wb+')
    f.write res.body
    f.close
    puts "write #{filename} to disc ok..."


    Thread.new do
      puts 'in zjhbk thread, now begin processing...'
      #-----------------------------------------------------

      #=begin
      begin
        excel = WIN32OLE.new('Excel.Application')
        excel.visible = false
        #filename='csrcindustry.xls'
        filename='E:\code\rails\TradePlan\csrcindustry.xls'
        #workbook = excel.Workbooks.Add()
        workbook = excel.Workbooks.Open(filename)
        worksheet = workbook.Worksheets(1)
        worksheet.select
        puts 'file opened suc...'

        data = worksheet.Range("a:a").Value
        linenumber = 0
        for linearr in data
          if linearr[0]
            linenumber += 1
          else
            break
          end
        end
        puts "csrcindustry.xls has #{linenumber} lines."
        records = worksheet.Range("a2:k#{linenumber}").Value


        line = 2
        shanghai = 'Shanghai'
        #shenzhen = 'Shenzhen'
        data = []
        market = 0

        records.each do |record|
          #while (record = worksheet.range("a#{line}:k#{line}"))
          #if line == 2
          #puts 'in loop...'
          #puts data.class
          puts "processing #{linenumber} -> #{line}"
          line += 1
          data = record
          #for i in record
          #  data<< i
          #end
          #puts "--->#{data[0]}:#{data[0].class}"
          if data.size == 0 || data[0].nil?
            break
          end
          #end
          #puts 'step 0'
          #puts data[1].value, data[1].value.class
          the_stock_category = StockCategory.find_by_name_and_family(data[-2], 1)
          #puts 'step 00'
          if the_stock_category.nil?
            the_stock_category = StockCategory.new
            the_stock_category.family = 1
            the_stock_category.name = data[-2]
            the_stock_category.save!
          end
          #puts 'step 1'
          if data[4] == shanghai
            market = 1
          else
            market = 0
          end
          #puts 'step 2....'
          the_stock = Stock.find_by_market_and_code(market, data[1])
          if the_stock.nil?
            the_stock = Stock.new
            the_stock.market = market
            the_stock.code = data[1]
            the_stock.name = data[2]
            the_stock.save!
          end
          #puts 'step 3....'
          a_stock_set = StockSet.find_by_stock_category_id_and_stock_id(the_stock_category.id, the_stock.id)
          if a_stock_set.nil?
            a_stock_set = StockSet.new
            a_stock_set.stock_category_id = the_stock_category.id
            a_stock_set.stock_id = the_stock.id
            a_stock_set.save
          end
          #puts 'step 4...'
        end

      rescue Exception => e
        puts e.class
        puts e.message
        workbook.close
        excel.quit
        raise
      else
        puts 'no exception in thread...'
      ensure
        workbook.close(1)
        excel.quit
      end

    end
  end

  def get_market_from_code(code)
    if code =~ /^6\d{5}$/
      1
    elsif code =~ /^30\d{4}$/ || code =~ /^0\d{5}$/
      0
    end
  end

  def process_jcybg
    puts 'begin process jcybg...'

    url = URI.parse('http://index.cninfo.com.cn/')
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.get("/files/yangben.xls")
    }
    filename='yangben.xls'
    puts "get yangben.xls from net ok."
    File.open(filename, 'wb+') { |f| f.write(res.body) }
    puts "write #{filename} to disc ok."


    Thread.new do
      puts 'in jcybg thread, now begin to process...'
      #-----------------------------------------------------
      #=begin
      begin
        excel = WIN32OLE.new('Excel.Application')
        excel.visible = false
        filename='E:\code\rails\TradePlan\yangben.xls'
        puts filename
        #workbook = excel.Workbooks.Add()
        workbook = excel.Workbooks.Open(filename)
        worksheet = workbook.Worksheets(1)
        worksheet.select
        puts 'file opened suc...'

        data = worksheet.Range("a:a").Value
        linenumber = 0
        for linearr in data
          if linearr[0]
            linenumber += 1
          else
            break
          end
        end
        puts "yangben.xls has #{linenumber} lines."
        records = worksheet.Range("a2:e#{linenumber}").Value

        line = 2
        stock_category_hash = {}
        #sample_stocks = []
        records.each do |record|
          #while (record = worksheet.Range("a#{line}:e#{line}"))
          puts "processing #{linenumber} -> #{line}"
          line += 1
          data = record
          #for i in record
          #  data<< i
          #end
          #puts "--->#{data[0]}:#{data[0].class}"
          if data.size == 0 || data[0].nil?
            break
          end
          #end
          #puts 'step 0'
          #puts data[1].class, data[1]
          the_index = StockCategory.find_by_code_and_family(data[1], 0)
          #puts 'step 00'
          if the_index.nil?
            the_index = StockCategory.new
            the_index.family = 0
            the_index.code = data[1]
            the_index.name = data[2]
            the_index.save!
          else
            if stock_category_hash.size == 0
              stock_category_hash[the_index.id] = []
            else
              keys = stock_category_hash.keys
              stock_ids = StockCategory.find(keys[0]).stock_sets.map { |x| x.stock_id }
              stock_ids = stock_ids - stock_category_hash[keys[0]]
              StockSet.delete(stock_ids) if stock_ids.size > 0
              stock_category_hash.delete(keys[0])
              stock_category_hash[the_index.id] = []
            end
            #sample_stocks = stock_category_hash[the_index]
          end
          #stock_category_hash[the_index] = []

          #puts 'step 1'
          #if data[3].value
          market = get_market_from_code(data[3])
          the_stock = Stock.find_by_market_and_code(market, data[3])
          if the_stock.nil?
            the_stock = Stock.new
            the_stock.market = market
            the_stock.code = data[3]
            the_stock.name = data[4]
            the_stock.save!
          end
          if stock_category_hash.include?(the_index.id)
            stock_category_hash[the_index.id] << the_stock.id
          end
          #puts 'step 3....'
          a_sample_stock = StockSet.find_by_stock_category_id_and_stock_id(the_index.id, the_stock.id)
          if a_sample_stock.nil?
            a_sample_stock = StockSet.new
            a_sample_stock.stock_category_id = the_index.id
            a_sample_stock.stock_id = the_stock.id
            a_sample_stock.save
          end
          #puts 'step 4...'
          #puts "process a#{line}:f#{line}"
        end
        puts 'done, now close workbook.'
      rescue Exception => e
        puts e.class
        puts e.message
        workbook.close
        excel.quit
        raise
      else
        puts 'no exception in thread...'
          #true
      ensure
        workbook.close
        excel.quit
      end

    end
  end

  def get_stock_ids_from_codes(codes, code_to_name_hash)
    stock_ids = []
    codes.each do |code|
      if @code_stock_id_map.has_key?(code)
        stock_ids << @code_stock_id_map[code]
      else
        market = get_market_from_code(code)
        the_stock = Stock.find_by_market_and_code(market, code)
        unless the_stock
          the_stock = Stock.new(:market => market, :code => code, :name => code_to_name_hash[code])
          the_stock.save!
        end
        stock_ids << the_stock.id
        @code_stock_id_map[code] = the_stock.id
      end

    end
    stock_ids
  end

  def process_jcybg_good
    puts 'begin process jcybg...'

    url = URI.parse('http://index.cninfo.com.cn/')
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.get("/files/yangben.xls")
    }
    filename='yangben.xls'
    puts "get yangben.xls from net ok."
    File.open(filename, 'wb+') { |f| f.write(res.body) }
    puts "write #{filename} to disc ok."


    Thread.new do
      puts 'in jcybg thread, now begin to process...'
      #-----------------------------------------------------
      #=begin
      begin
        excel = WIN32OLE.new('Excel.Application')
        excel.visible = false
        filename='E:\code\rails\TradePlan\yangben.xls'
        puts filename
        #workbook = excel.Workbooks.Add()
        workbook = excel.Workbooks.Open(filename)
        worksheet = workbook.Worksheets(1)
        worksheet.select
        puts 'file opened suc...'

        data = worksheet.Range("a:a").Value
        linenumber = 0
        for linearr in data
          if linearr[0]
            linenumber += 1
          else
            break
          end
        end
        puts "yangben.xls has #{linenumber} lines."
        records = worksheet.Range("a2:e#{linenumber}").Value

        index_stock_map_hash = {}
        index_name_map_hash = {}
        stock_name_map_hash = {}
        #data[1] is index code
        records.each do |line|
          stocks = []
          if index_stock_map_hash.has_key? line[1]
            stocks = index_stock_map_hash[line[1]]
          else
            index_stock_map_hash[line[1]] = stocks
            index_name_map_hash[line[1]] = line[2]
          end
          stocks << line[3]
          stock_name_map_hash[line[3]] = line[4]
        end
        progress = 0
        index_stock_map_hash.each do |index_code, stocks|
          progress += 1
          puts "processing #{index_stock_map_hash.size} -> #{progress}"
          the_stock_category = StockCategory.find_by_family_and_code(0, index_code)
          if (the_stock_category)
            exist_stocks = the_stock_category.stock_sets.map { |elm| elm.stock_id }
            excel_stocks = get_stock_ids_from_codes(stocks, stock_name_map_hash)

            stocks_need_to_insert = excel_stocks - exist_stocks
            stocks_need_to_delete = exist_stocks - excel_stocks
            stocks_need_to_insert.each do |stock_id|
              puts "++++++>insert #{stock_id}"
              a_stock_set = StockSet.new(:stock_category_id => the_stock_category.id, :stock_id => stock_id)
              a_stock_set.save
            end
            stocks_need_to_delete.each do |stock_id|
              puts "------>delete #{stock_id}"
              StockSet.where("stock_category_id = ? AND stock_id = ?", the_stock_category.id, stock_id).delete_all
            end

          else
            #全部插入
            the_stock_category = StockCategory.new(:family => 0, :code => index_code, :name => index_name_map_hash[index_code])
            the_stock_category.save!
            excel_stocks = get_stock_ids_from_codes(stocks, stock_name_map_hash)
            excel_stocks.each do |stock_id|
              puts "++++++>insert #{stock_id}"
              a_stock_set = StockSet.new(:stock_category_id => the_stock_category.id, :stock_id => stock_id)
              a_stock_set.save
            end
          end
        end
        #------------------------------------------------------------------------------

        puts 'done, now close workbook.'
      rescue Exception => e
        puts e.class
        puts e.message
        workbook.close
        excel.quit
        raise
      else
        puts 'no exception in thread...'
          #true
      ensure
        workbook.close
        excel.quit
      end
    end
  end


end
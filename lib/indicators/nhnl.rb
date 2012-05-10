require "xmlrpc/client"

class Nhnl
  SH_A = 86
  SZ_A = 88
  SH_SZ_A = 92
  ZX_A = 98
  CYB_A = 100
  BARS_OF_YEAR = 249

  def self.dump
    nhnlhs = calculate(CYB_A)
    File.open('nhnl.txt','w') do |f|
      nhnlhs.each do |k,v|
        f.puts "#{k}: nh=#{v[:nh]}, nl=#{v[:nl]}"
      end
    end
  end

  def self.calculate(category_id)
    recorder = {}
    server = XMLRPC::Client.new2("http://localhost:8080")
    stocks = StockCategory.find(category_id).stock_sets
    total_stocks = stocks.size
    counter = 0
    stocks.each do |stock|
      counter += 1
      his_data = []
      tries = 0
      begin
        tries += 1
        his_data = server.call("get_stock_his_data",stock.stock_id,0)
      rescue => e
        if tries < 4
          sleep(2**tries)
          retry
        else
          next
        end
      end
      next if his_data.size <= BARS_OF_YEAR
      min_index = BARS_OF_YEAR < his_data.size - 20 ? BARS_OF_YEAR : his_data.size - 20
      min_index.upto(his_data.size-1) do |index|
        recorder[ his_data[index][0] ] = { nh: 0,nl: 0, other:0 }  unless recorder.has_key?  his_data[index][0]
        tmphs = recorder[ his_data[index][0] ]
        high_of_year = his_data[index-BARS_OF_YEAR,BARS_OF_YEAR+1].inject {|max,x| max[1] < x[1] ? x : max }
        low_of_year = his_data[index-BARS_OF_YEAR,BARS_OF_YEAR+1].inject {|min,x| min[2] < x[2] ? min : x }
        if his_data[index][1] == high_of_year
          tmphs[:nh] += 1
        elsif his_data[index][2] == low_of_year
          tmphs[:nl] += 1
        else
          tmphs[:other] += 1
        end
      end
      puts "complete #{100.0 * counter/total_stocks}%"
    end
    nhnl = {}
    recorder.each do |key,value|
      total = value[:nh] + value[:nl] + value[:other]
      nhnl[key] = {nh: value[:nh]/total , nl: value[:nl]/total}
    end
    # return value
    nhnl
  end
end
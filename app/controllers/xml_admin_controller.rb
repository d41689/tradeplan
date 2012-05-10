require "rexml/document"
include REXML
  SIGNAL = 1
  TRADE_RECORD = 2
  DEMO_VALUE = 3
  XML_STRING_TYPE = [
    ['信号', SIGNAL],
    ['交易记录', TRADE_RECORD],
    ['模拟市值', DEMO_VALUE]
  ]

class XmlAdminController < ApplicationController

  def load_data
    load_signals_from_xml
    load_demo_market_value_from_xml
    load_trade_records_from_xml
  end

  #用于上传一段xml，解释后插进数据库
  def upload_xml_string

  end

  def create_from_form
    puts "#{params['xml_type']},#{params['xml']}"
    if params[:xml].nil?
      redirect_to :action => 'upload_xml_string', :notice => "xml 不能为空" and return
    end
    doc = Document.new(params[:xml])
    case params[:xml_type].to_i
      when SIGNAL then
        load_signals_from_xml(doc)
      when TRADE_RECORD then
        load_trade_records_from_xml(doc)
      when DEMO_VALUE then
        load_demo_market_value_from_xml(doc)
      else
        redirect_to :action => 'upload_xml_string', :notice => "xml_type 不对" and return
    end
    redirect_to :action => 'upload_xml_string'
  end

  private

  def load_signals_from_xml(doc = nil)
    if doc.nil?
      StockSignal.delete_all
      doc = Document.new(File.new("app/resources/signals.xml"))
    end
    doc.elements.each("*/daySignals/signal") do |element|
      StockSignal.create(
          :code => element.elements['code'].text,
          :signal_type => element.elements['signal_type'].text,
          :operation => element.elements['operation'].text,
          :buy_price => element.elements['buy_price'].text,
          :initial_stop_price => element.elements['initial_stop_price'].text,
          :stop_price => element.elements['stop_price'].text,
          :his_performance => element.elements['his_performance'].text,
          :long_trend => element.elements['long_trend'].text,
          :mid_trend => element.elements['mid_trend'].text,
          :short_trend => element.elements['short_trend'].text,
          :mkt_long_trend => element.elements['mkt_long_trend'].text,
          :mkt_mid_trend => element.elements['mkt_mid_trend'].text,
          :buy_date => element.elements['buy_date'].text,
          :sell_date => element.elements['sell_date'].text)
    end
  end

  def load_trade_records_from_xml(doc = nil)
    if doc.nil?
      DemoTradeRecord.delete_all
      doc = Document.new(File.new("app/resources/TradeHis.xml"))
    end
    doc.elements.each("trade_records/trade_record") do |element|
      DemoTradeRecord.create(
          :trade_date => element.elements['trade_date'].text,
          :operation => element.elements['operation'].text,
          :code => element.elements['code'].text,
          :quantity => element.elements['quantity'].text,
          :price => element.elements['price'].text,
          :profit => element.elements['profit'].text,
          :profit_rate => element.elements['profit_rate'].text)
    end
  end

  def load_demo_market_value_from_xml(doc = nil)
    if doc.nil?
      DemoMarketValue.delete_all
      doc = Document.new(File.new("app/resources/capitalHis.xml"))
    end
    doc.elements.each("all/day") do |element|
      DemoMarketValue.create(
          :day => element.attributes['date'],
          :total => element.elements['total'].text,
          :mkt_index => element.elements['index'].text)
    end
  end

end

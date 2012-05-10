class AddzfToStockFinancialData < ActiveRecord::Migration
  def self.up
    add_column :stock_financial_data, :u5, :decimal, :precision => 8,:scale => 2
    add_column :stock_financial_data, :u30, :decimal, :precision => 8,:scale => 2
    add_column :stock_financial_data, :u90, :decimal, :precision => 8,:scale => 2
    add_column :stock_financial_data, :u180, :decimal, :precision => 8,:scale => 2
    add_column :stock_financial_data, :u360, :decimal, :precision => 8,:scale => 2
  end

  def self.down
    remove_column :stock_financial_data, :u360
    remove_column :stock_financial_data, :u180
    remove_column :stock_financial_data, :u90
    remove_column :stock_financial_data, :u30
    remove_column :stock_financial_data, :u5
  end
end

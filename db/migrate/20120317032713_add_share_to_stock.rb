class AddShareToStock < ActiveRecord::Migration
  def self.up
    add_column :stocks, :sell_price, :decimal, :precision => 8, :scale => 2
    add_column :stocks, :buy_price, :decimal, :precision => 8, :scale => 2
    add_column :stocks, :high_break, :decimal, :precision => 8, :scale => 2
    add_column :stocks, :low_break, :decimal, :precision => 8, :scale => 2
    add_column :stocks, :dkflag, :integer
    add_column :stocks, :tbp, :decimal, :precision => 8, :scale => 2
    add_column :stocks, :stop_lost, :decimal, :precision => 8, :scale => 2
    add_column :stocks, :take_profit, :decimal, :precision => 8, :scale => 2

    add_column :stocks, :active_capital, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :zgb, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :zzc, :decimal, :precision => 16, :scale => 2

    add_column :stocks, :gdzc, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :wxzc, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :jzc, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :btsy, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :yywsz, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :lyze, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :shly, :decimal, :precision => 16, :scale => 2


    add_column :stocks, :mgsy, :decimal, :precision => 10, :scale => 4
    #add_column :stocks, :mgjzc, :decimal, :precision => 8, :scale => 2
    add_column :stocks, :gdqyb, :decimal, :precision => 8, :scale => 4

    add_column :stocks, :zbgjj,:decimal, :precision => 16, :scale => 2
    add_column :stocks, :zysy, :decimal, :precision => 16, :scale => 2
    add_column :stocks,  :zyly, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :yyly, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :tzsy,:decimal, :precision => 16, :scale => 2
    add_column :stocks, :jly, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :wfply, :decimal, :precision => 16, :scale => 2
    add_column :stocks, :mgjzc,:decimal, :precision => 8, :scale => 2
    add_column :stocks, :jyl,:decimal, :precision => 8, :scale => 2
    add_column :stocks, :mgwfp,:decimal, :precision => 8, :scale => 2
    add_column :stocks, :mggjj,:decimal, :precision => 8, :scale => 2
  end

  def self.down

    remove_column :stocks, :mggjj
    remove_column :stocks, :mgwfp
    remove_column :stocks, :jyl
    remove_column :stocks, :mgjzc
    remove_column :stocks, :wfply
    remove_column :stocks, :jly
    remove_column :stocks, :tzsy
    remove_column :stocks, :yyly
    remove_column :stocks,  :zyly
    remove_column :stocks, :zysy
    remove_column :stocks, :zbgjj

    remove_column :stocks, :gdqyb
    #remove_column :stocks, :mgjzc
    remove_column :stocks, :mgsy

    remove_column :stocks, :shly
    remove_column :stocks, :lyze
    remove_column :stocks, :yywsz
    remove_column :stocks, :btsy
    remove_column :stocks, :jzc
    remove_column :stocks, :wxzc
    remove_column :stocks, :gdzc

    remove_column :stocks, :zzc
    remove_column :stocks, :zgb
    remove_column :stocks, :active_capital
    remove_column :stocks, :take_profit
    remove_column :stocks, :stop_lost
    remove_column :stocks, :tbp
    remove_column :stocks, :dkflag
    remove_column :stocks, :low_break
    remove_column :stocks, :high_break
    remove_column :stocks, :buy_price
    remove_column :stocks, :sell_price
  end
end

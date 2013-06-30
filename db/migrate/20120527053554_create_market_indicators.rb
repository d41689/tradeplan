class CreateMarketIndicators < ActiveRecord::Migration
  def change
    create_table :market_indicators do |t|
      t.integer :nhnl
      t.decimal :trin, :precision => 8, :scale => 4

      #t.timestamps
    end
  end
end

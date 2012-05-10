# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120411132609) do

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

  create_table "day_tasks", :force => true do |t|
    t.date     "day",                       :null => false
    t.integer  "windin",     :default => 0
    t.integer  "csindex",    :default => 0
    t.integer  "cninfo",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demo_market_values", :force => true do |t|
    t.date     "day",                                       :null => false
    t.decimal  "total",      :precision => 16, :scale => 2, :null => false
    t.decimal  "mkt_index",  :precision => 8,  :scale => 2, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demo_trade_records", :force => true do |t|
    t.date     "trade_date",                                              :null => false
    t.string   "code",        :limit => 6,                                :null => false
    t.string   "operation",   :limit => 4,                                :null => false
    t.float    "price",                                                   :null => false
    t.integer  "quantity",                                                :null => false
    t.decimal  "profit",                   :precision => 10, :scale => 0
    t.decimal  "profit_rate",              :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "his_data", :force => true do |t|
    t.integer "stock_id",     :null => false
    t.binary  "day_data"
    t.integer "day_number"
    t.binary  "week_data"
    t.integer "week_number"
    t.binary  "month_data"
    t.integer "month_number"
    t.binary  "hour_data"
    t.integer "hour_number"
  end

  create_table "stock_categories", :force => true do |t|
    t.string   "name",       :limit => 48,                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "family",                   :default => 0, :null => false
    t.string   "code",       :limit => 6
  end

  create_table "stock_day_his_data", :force => true do |t|
    t.integer "stock_id",                                :null => false
    t.date    "day",                                     :null => false
    t.decimal "open",     :precision => 10, :scale => 4, :null => false
    t.decimal "high",     :precision => 10, :scale => 4, :null => false
    t.decimal "low",      :precision => 10, :scale => 4, :null => false
    t.decimal "close",    :precision => 10, :scale => 4, :null => false
    t.decimal "amount",   :precision => 16, :scale => 2, :null => false
    t.integer "volume",                                  :null => false
  end

  add_index "stock_day_his_data", ["stock_id"], :name => "day_stock_id_index"

  create_table "stock_financial_data", :force => true do |t|
    t.integer "stock_id",                                  :null => false
    t.date    "day",                                       :null => false
    t.decimal "zsz",        :precision => 16, :scale => 4
    t.decimal "ltsz",       :precision => 16, :scale => 4
    t.decimal "ltgb",       :precision => 16, :scale => 4
    t.decimal "zgb",        :precision => 16, :scale => 4
    t.decimal "zysr_ttm",   :precision => 16, :scale => 4
    t.decimal "price",      :precision => 10, :scale => 2
    t.decimal "pe_ttm",     :precision => 10, :scale => 2
    t.decimal "pe_lyr",     :precision => 10, :scale => 2
    t.decimal "pe_d",       :precision => 10, :scale => 2
    t.decimal "mrq",        :precision => 10, :scale => 2
    t.decimal "mrr",        :precision => 10, :scale => 2
    t.decimal "profit_ttm", :precision => 10, :scale => 4
    t.decimal "mgjzc",      :precision => 10, :scale => 2
    t.decimal "jzcsyl_ttm", :precision => 8,  :scale => 2
    t.decimal "mll_ttm",    :precision => 8,  :scale => 2
    t.decimal "u5",         :precision => 8,  :scale => 2
    t.decimal "u30",        :precision => 8,  :scale => 2
    t.decimal "u90",        :precision => 8,  :scale => 2
    t.decimal "u180",       :precision => 8,  :scale => 2
    t.decimal "u360",       :precision => 8,  :scale => 2
  end

  create_table "stock_hour_his_data", :force => true do |t|
    t.integer  "stock_id",                                :null => false
    t.datetime "day",                                     :null => false
    t.decimal  "open",     :precision => 10, :scale => 4, :null => false
    t.decimal  "high",     :precision => 10, :scale => 4, :null => false
    t.decimal  "low",      :precision => 10, :scale => 4, :null => false
    t.decimal  "close",    :precision => 10, :scale => 4, :null => false
    t.decimal  "amount",   :precision => 16, :scale => 2, :null => false
    t.integer  "volume",                                  :null => false
  end

  add_index "stock_hour_his_data", ["stock_id"], :name => "hour_stock_id_index"

  create_table "stock_month_his_data", :force => true do |t|
    t.integer "stock_id",                                :null => false
    t.date    "day",                                     :null => false
    t.decimal "open",     :precision => 10, :scale => 4, :null => false
    t.decimal "high",     :precision => 10, :scale => 4, :null => false
    t.decimal "low",      :precision => 10, :scale => 4, :null => false
    t.decimal "close",    :precision => 10, :scale => 4, :null => false
    t.decimal "amount",   :precision => 16, :scale => 2, :null => false
    t.integer "volume",                                  :null => false
  end

  add_index "stock_month_his_data", ["stock_id"], :name => "month_stock_id_index"

  create_table "stock_sets", :force => true do |t|
    t.integer  "stock_category_id"
    t.integer  "stock_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stock_sets", ["stock_category_id"], :name => "fk_stock_categories"
  add_index "stock_sets", ["stock_id"], :name => "fk_stocks"

  create_table "stock_signals", :force => true do |t|
    t.string   "code",               :limit => 6, :null => false
    t.integer  "signal_type",                     :null => false
    t.integer  "operation",                       :null => false
    t.float    "buy_price",                       :null => false
    t.float    "initial_stop_price",              :null => false
    t.float    "stop_price",                      :null => false
    t.float    "his_performance",                 :null => false
    t.integer  "long_trend",                      :null => false
    t.integer  "mid_trend",                       :null => false
    t.integer  "short_trend",                     :null => false
    t.integer  "mkt_long_trend",                  :null => false
    t.integer  "mkt_mid_trend",                   :null => false
    t.date     "buy_date",                        :null => false
    t.date     "sell_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_ttm_infos", :force => true do |t|
    t.integer  "stock_id"
    t.decimal  "share",      :precision => 16, :scale => 2
    t.decimal  "profit",     :precision => 10, :scale => 4
    t.decimal  "price",      :precision => 8,  :scale => 2
    t.date     "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_week_his_data", :force => true do |t|
    t.integer "stock_id",                                :null => false
    t.date    "day",                                     :null => false
    t.decimal "open",     :precision => 10, :scale => 4, :null => false
    t.decimal "high",     :precision => 10, :scale => 4, :null => false
    t.decimal "low",      :precision => 10, :scale => 4, :null => false
    t.decimal "close",    :precision => 10, :scale => 4, :null => false
    t.decimal "amount",   :precision => 16, :scale => 2, :null => false
    t.integer "volume",                                  :null => false
  end

  add_index "stock_week_his_data", ["stock_id"], :name => "week_stock_id_index"

  create_table "stocks", :force => true do |t|
    t.integer  "market"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "sell_price",     :precision => 8,  :scale => 2
    t.decimal  "buy_price",      :precision => 8,  :scale => 2
    t.decimal  "high_break",     :precision => 8,  :scale => 2
    t.decimal  "low_break",      :precision => 8,  :scale => 2
    t.integer  "dkflag"
    t.decimal  "tbp",            :precision => 8,  :scale => 2
    t.decimal  "stop_lost",      :precision => 8,  :scale => 2
    t.decimal  "take_profit",    :precision => 8,  :scale => 2
    t.decimal  "active_capital", :precision => 16, :scale => 2
    t.decimal  "zgb",            :precision => 16, :scale => 2
    t.decimal  "zzc",            :precision => 16, :scale => 2
    t.decimal  "gdzc",           :precision => 16, :scale => 2
    t.decimal  "wxzc",           :precision => 16, :scale => 2
    t.decimal  "jzc",            :precision => 16, :scale => 2
    t.decimal  "btsy",           :precision => 16, :scale => 2
    t.decimal  "yywsz",          :precision => 16, :scale => 2
    t.decimal  "lyze",           :precision => 16, :scale => 2
    t.decimal  "shly",           :precision => 16, :scale => 2
    t.decimal  "mgsy",           :precision => 10, :scale => 4
    t.decimal  "gdqyb",          :precision => 8,  :scale => 4
    t.decimal  "zbgjj",          :precision => 16, :scale => 2
    t.decimal  "zysy",           :precision => 16, :scale => 2
    t.decimal  "zyly",           :precision => 16, :scale => 2
    t.decimal  "yyly",           :precision => 16, :scale => 2
    t.decimal  "tzsy",           :precision => 16, :scale => 2
    t.decimal  "jly",            :precision => 16, :scale => 2
    t.decimal  "wfply",          :precision => 16, :scale => 2
    t.decimal  "mgjzc",          :precision => 8,  :scale => 2
    t.decimal  "jyl",            :precision => 8,  :scale => 2
    t.decimal  "mgwfp",          :precision => 8,  :scale => 2
    t.decimal  "mggjj",          :precision => 8,  :scale => 2
  end

  create_table "users", :force => true do |t|
    t.integer  "invite_num",                         :default => 0,    :null => false
    t.boolean  "is_first_visit_today",               :default => true, :null => false
    t.string   "networkUid",           :limit => 50,                   :null => false
    t.integer  "network",                                              :null => false
    t.boolean  "sex",                                                  :null => false
    t.integer  "experience",                                           :null => false
    t.string   "first_name",           :limit => 20,                   :null => false
    t.string   "full_name",            :limit => 20,                   :null => false
    t.string   "imageUrl"
    t.string   "largeImageUrl"
    t.boolean  "hasProfileBoxImage",                                   :null => false
    t.string   "profileUrl",           :limit => 1,                    :null => false
    t.boolean  "appInstalled",                                         :null => false
    t.integer  "credit",                             :default => 0,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

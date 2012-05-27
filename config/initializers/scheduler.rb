require 'rubygems'
require 'rufus/scheduler'
require 'windin_client'
require 'thread'

semaphore = Mutex.new
$current_day = nil

NOT_PROCESSED = 0
PROCESSING = 1
#PROCESS_FAILED = 2
#PROCESS_SUCCEED = 3

scheduler = Rufus::Scheduler.start_new

scheduler.in '20m' do
  puts "order ristretto"
end

=begin
scheduler.at 'Thu Mar 26 07:31:43 +0900 2009' do
  puts 'order pizza'
end
=end

scheduler.cron '0 22 * * 1-5' do
  # every day of the week at 22:00 (10pm)
  puts 'activate security system'
end


def get_current_date
  unless $current_day
    codes = ['600036', '601988', '601998', '601398', '601628', '600519']
    client = WindinClient.new
    i = 0
    until client.fetch_data(1, codes[i])
      puts "fetch data from windin failed.#{codes[i]}"
      i += 1
      i = 0 if codes.size == i
      sleep(2**i)
    end
    $current_day = client.current_day
    puts "current_day is #{$current_day}"
  end
  $current_day
end

#=begin 临时屏蔽
#process windin
scheduler.every '1m' do
  puts 'Processing windin data...'
  #day_task = DayTask.find_by_day(Date.today)
  t = Thread.new {
    semaphore.synchronize do
      day_task = DayTask.find_by_day($current_day) if get_current_date()
      if $current_day.nil?
        false
      elsif day_task.nil? && $current_day
        day_task = DayTask.new
        day_task.day = $current_day
        day_task.windin = PROCESSING
        day_task.save
        true
      elsif day_task.windin == PROCESSING
        false
      else
        #day_task.windin = PROCESSING
        day_task.update_attribute(:windin, PROCESSING)
        true
      end
    end
  }
  puts t, t.class, t.value
  if t.value
    puts 'windin data not get yet...'
    begin
      WindinClient.new.fill_stock_financial_data_table
      WindinClient.prepare
    rescue Exception => e
      #process failed.
      puts e.message
      puts e.class
      Thread.new {
        semaphore.synchronize {
          day_task = DayTask.find_by_day($current_day)
          if day_task.nil?
            puts 'error...1'
          elsif day_task.windin == PROCESSING
            day_task.windin = NOT_PROCESSED
            day_task.update_attribute(:windin, NOT_PROCESSED)
          else
            puts 'error...2'
          end
        }
      }
    end
  end
end
#证监会
scheduler.every '15m' do
  puts 'Processing zhengjianhui data...'

  t = Thread.new {
    semaphore.synchronize {
      day_task = DayTask.find_by_day($current_day) if get_current_date()
      if $current_day.nil?
        false
      elsif day_task.nil? && $current_day
        day_task = DayTask.new
        day_task.day = $current_day
        day_task.csindex = PROCESSING
        day_task.save
        true
      elsif day_task.csindex == PROCESSING
        false
      else
        day_task.csindex = PROCESSING
        day_task.update_attribute(:csindex, PROCESSING)
        true
      end
    }
  }
  puts t, t.class, t.value
  if t.value
    puts 'zhengjianhui data not get yet...'
    begin
      c = SZXXClient.new
      c.process_zjhbk
    rescue Exception => e
      #process failed.
      puts e.message
      puts e.class
      Thread.new {
        semaphore.synchronize {
          day_task = DayTask.find_by_day($current_day)
          if day_task.nil?
            puts 'error...1'
          elsif day_task.csindex == PROCESSING
            day_task.csindex = NOT_PROCESSED
            day_task.update_attribute(:csindex, NOT_PROCESSED)
          else
            puts 'error...2'
          end
        }
      }
    end
  end
end
#巨潮
scheduler.every '15m' do
  puts 'Processing juchao data...'

  t = Thread.new {
    semaphore.synchronize {
      day_task = DayTask.find_by_day($current_day) if get_current_date()
      if $current_day.nil?
        false
      elsif day_task.nil? && $current_day
        day_task = DayTask.new
        day_task.day = $current_day
        day_task.cninfo = PROCESSING
        day_task.save
        true
      elsif day_task.cninfo == PROCESSING
        false
      else
        day_task.cninfo = PROCESSING
        day_task.update_attribute(:cninfo, PROCESSING)
        true
      end
    }
  }
  puts t, t.class, t.value
  if t.value
    puts 'cninfo data not get yet...'
    begin
      c = SZXXClient.new
      c.process_jcybg_good
    rescue Exception => e
      #process failed.
      puts e.message
      puts e.class
      Thread.new {
        semaphore.synchronize {
          day_task = DayTask.find_by_day($current_day)
          if day_task.nil?
            puts 'error...1'
          elsif day_task.cninfo == PROCESSING
            day_task.cninfo = NOT_PROCESSED
            day_task.update_attribute(:cninfo, NOT_PROCESSED)
          else
            puts 'error...2'
          end
        }
      }
    end
  end
end

#=end


#------------------------------------------------------------------------------------------------
=begin
#process 证监会板块
scheduler.every '1m' do
  puts 'Processing windin data...'
  day_task = DayTask.find_by_day(Date.today)
  if day_task.nil?
    puts 'task not exist today'
    day_task = DayTask.new
    day_task.day = Date.today.to_s
    day_task.save!
    WindinClient.new.fill_stock_financial_data_table
    BlockTtm.prepare
    day_task.windin = 1

    day_task.csindex = 1
    c.process_jcybg
    day_task.cninfo = 1
    day_task.update!
  else
    puts 'need to implement...'

  end
end

#巨潮板块
scheduler.every '1m' do
  puts 'Processing windin data...'
  day_task = DayTask.find_by_day(Date.today)
  if day_task.nil?
    puts 'task not exist today'
    day_task = DayTask.new
    day_task.day = Date.today.to_s
    day_task.save!
    WindinClient.new.fill_stock_financial_data_table
    BlockTtm.prepare
    day_task.windin = 1
    c = SZXXClient.new
    c.process_zjhbk
    day_task.csindex = 1
    c.process_jcybg
    day_task.cninfo = 1
    day_task.update!
  else
    puts 'need to implement...'

  end
end


=end
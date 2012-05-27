require 'windin_client'
class BlockTtmsController < ApplicationController
  # GET /block_ttms
  # GET /block_ttms.xml
  def index
    @block_ttms = BlockTtm.find_all_by_day(BlockTtm.order("day desc").limit(1).first.day)

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @block_ttms }
    end
  end

  # GET /block_ttms/1
  # GET /block_ttms/1.xml
  def show
    @block_ttm = BlockTtm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @block_ttm }
    end
  end

  # GET /block_ttms/new
  # GET /block_ttms/new.xml
  def new
    @block_ttm = BlockTtm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @block_ttm }
    end
  end

  # GET /block_ttms/1/edit
  def edit
    @block_ttm = BlockTtm.find(params[:id])
  end

  # POST /block_ttms
  # POST /block_ttms.xml
  def create
    @block_ttm = BlockTtm.new(params[:block_ttm])

    respond_to do |format|
      if @block_ttm.save
        format.html { redirect_to(@block_ttm, :notice => 'Block ttm was successfully created.') }
        format.xml { render :xml => @block_ttm, :status => :created, :location => @block_ttm }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @block_ttm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /block_ttms/1
  # PUT /block_ttms/1.xml
  def update
    @block_ttm = BlockTtm.find(params[:id])

    respond_to do |format|
      if @block_ttm.update_attributes(params[:block_ttm])
        format.html { redirect_to(@block_ttm, :notice => 'Block ttm was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @block_ttm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /block_ttms/1
  # DELETE /block_ttms/1.xml
  def destroy
    @block_ttm = BlockTtm.find(params[:id])
    @block_ttm.destroy

    respond_to do |format|
      format.html { redirect_to(block_ttms_url) }
      format.xml { head :ok }
    end
  end

  def show_sttm
    respond_to do |format|
      format.json {
        chart = OpenFlashChart.new() do |c|
          #values = []
          sttm_values = []
          keys = []
          ttms = BlockTtm.find_all_by_stock_category_id(params[:id])
          ttms.each do |ttm|
            #fttm = ttm.ttm.to_f
            fsttm = ttm.sttm.to_f

            if fsttm <0.01 && fsttm > -0.01
              sttm_values << nil
            else
              sttm_values << fsttm
            end

            keys << ttm.day
          end
          title = Title.new()
          title.text = StockCategory.find(params[:id]).name
          title.style = "{font-size: 30px;color: #ff00ff; font-family: Verdana; text-align: center;}"
          c.title = title

          hol = HollowDot.new
          hol.size = 3
          hol.halo_size = 1
          hol.set_tooltip('#x_label#<br>#val#')


          sttm_line = Line.new
          sttm_line.text = 'sttm'
          sttm_line.colour = '#ff0000'
          sttm_line.set_default_dot_style(hol)
          sttm_line.set_values sttm_values
          c << sttm_line


          tmp = sttm_values.dup
          tmp.delete(nil)
          puts ""
          puts "sttm_values:"
          puts sttm_values
          puts "tmp:"
          puts tmp
          min = tmp.inject() { |m, x| m = m < x ? m : x }
          max = tmp.inject() { |m, x| m = m > x ? m : x }

          y_axis = YAxis.new
          y_axis.set_min min
          y_axis.set_max max
          y_axis.set_steps((max-min)/10)
          c.set_y_axis(y_axis)

          x_axis = XAxis.new
          x_axis.set_stroke(1)
          x_axis.set_colour("#428c3e")
          x_axis.set_tick_height(5)
          x_axis.set_grid_colour('#86BF83')
          x_axis.set_steps(1)

          labels = XAxisLabels.new
          labels.set_steps(2)
          labels.set_vertical
          labels.set_colour('#ff0000')
          labels.set_size(16)
          tmp = []
          tmp << 'one'
          tmp << 'two'
          tmp << 'three'
          tmp << 'four'
          tmp << 'five'

          tmp << XAxisLabel.new("six", "#0000ff", 30, 270)
          tmp << XAxisLabel.new("seven", "#0000ff", 30, 270)
          eight = XAxisLabel.new("eight", "#8c773e", 16, 315)
          eight.set_visible
          tmp << eight

          tmp << XAxisLabel.new("nine", "#2683cf", 16, 0)

          #labels.set_labels tmp
          labels.set_labels(keys)
          x_axis.set_labels labels
          c.set_x_axis x_axis

        end

        puts '====================================='
        puts chart.to_s
        json_txt = %!{ "elements": [ { "type": "line", "values": [ 5, 5, 5, 5, 5, 6, 5, 5, 4, 6 ], "dot-style": { "type": "hollow-dot", "dot-size": 3, "halo-size": 1, "tip": "#x_label#
#val#" } } ], "title": { "text": "X Axis Labels Complex Example" }, "x_axis": { "stroke": 1, "colour": "#428C3E", "tick-height": 5, "grid-colour": "#86BF83", "steps": 1, "labels": { "steps": 2, "rotate": 270, "colour": "#ff0000", "size": 16, "labels": [ "one", "two", "three", "four", "five", { "text": "six", "colour": "#0000FF", "size": 30, "rotate": 270 }, { "text": "seven", "colour": "#0000FF", "size": 30, "rotate": 270 }, { "text": "eight", "colour": "#8C773E", "size": 16, "rotate": 315, "visible": true }, { "text": "nine", "colour": "#2683CF", "size": 16, "rotate": 0 } ] } } }!
        render :text => chart.to_s, :layout => false
      }
    end
  end

  def show_wmrq
    respond_to do |format|
      format.json {
        chart = OpenFlashChart.new() do |c|
          #values = []
          sttm_values = []
          keys = []
          ttms = BlockTtm.find_all_by_stock_category_id(params[:id])
          ttms.each do |ttm|
            #fttm = ttm.ttm.to_f
            fsttm = ttm.wmrq.to_f

            if fsttm <0.01 && fsttm > -0.01
              sttm_values << nil
            else
              sttm_values << fsttm
            end

            keys << ttm.day
          end
          title = Title.new()
          title.text = StockCategory.find(params[:id]).name
          title.style = "{font-size: 30px;color: #ff00ff; font-family: Verdana; text-align: center;}"
          c.title = title

          hol = HollowDot.new
          hol.size = 3
          hol.halo_size = 1
          hol.set_tooltip('#x_label#<br>#val#')


          sttm_line = Line.new
          sttm_line.text = 'wmrq'
          sttm_line.colour = '#ff0000'
          sttm_line.set_default_dot_style(hol)
          sttm_line.set_values sttm_values
          c << sttm_line


          tmp = sttm_values.dup
          tmp.delete(nil)
          puts ""
          puts "sttm_values:"
          puts sttm_values
          puts "tmp:"
          puts tmp
          min = tmp.inject() { |m, x| m = m < x ? m : x }
          max = tmp.inject() { |m, x| m = m > x ? m : x }

          y_axis = YAxis.new
          y_axis.set_min min
          y_axis.set_max max
          y_axis.set_steps((max-min)/10)
          c.set_y_axis(y_axis)

          x_axis = XAxis.new
          x_axis.set_stroke(1)
          x_axis.set_colour("#428c3e")
          x_axis.set_tick_height(5)
          x_axis.set_grid_colour('#86BF83')
          x_axis.set_steps(1)

          labels = XAxisLabels.new
          labels.set_steps(2)
          labels.set_vertical
          labels.set_colour('#ff0000')
          labels.set_size(16)
          tmp = []
          tmp << 'one'
          tmp << 'two'
          tmp << 'three'
          tmp << 'four'
          tmp << 'five'

          tmp << XAxisLabel.new("six", "#0000ff", 30, 270)
          tmp << XAxisLabel.new("seven", "#0000ff", 30, 270)
          eight = XAxisLabel.new("eight", "#8c773e", 16, 315)
          eight.set_visible
          tmp << eight

          tmp << XAxisLabel.new("nine", "#2683cf", 16, 0)

          #labels.set_labels tmp
          labels.set_labels(keys)
          x_axis.set_labels labels
          c.set_x_axis x_axis

        end

        puts '====================================='
        puts chart.to_s
        render :text => chart.to_s, :layout => false
      }
    end
  end

  def show_smrq
    respond_to do |format|
      format.json {
        chart = OpenFlashChart.new() do |c|
          #values = []
          sttm_values = []
          keys = []
          ttms = BlockTtm.find_all_by_stock_category_id(params[:id])
          ttms.each do |ttm|
            #fttm = ttm.ttm.to_f
            fsttm = ttm.smrq.to_f

            if fsttm <0.01 && fsttm > -0.01
              sttm_values << nil
            else
              sttm_values << fsttm
            end

            keys << ttm.day
          end
          title = Title.new()
          title.text = StockCategory.find(params[:id]).name
          title.style = "{font-size: 30px;color: #ff00ff; font-family: Verdana; text-align: center;}"
          c.title = title

          hol = HollowDot.new
          hol.size = 3
          hol.halo_size = 1
          hol.set_tooltip('#x_label#<br>#val#')


          sttm_line = Line.new
          sttm_line.text = 'smrq'
          sttm_line.colour = '#ff0000'
          sttm_line.set_default_dot_style(hol)
          sttm_line.set_values sttm_values
          c << sttm_line


          tmp = sttm_values.dup
          tmp.delete(nil)
          puts ""
          puts "sttm_values:"
          puts sttm_values
          puts "tmp:"
          puts tmp
          min = tmp.inject() { |m, x| m = m < x ? m : x }
          max = tmp.inject() { |m, x| m = m > x ? m : x }

          y_axis = YAxis.new
          y_axis.set_min min
          y_axis.set_max max
          y_axis.set_steps((max-min)/10)
          c.set_y_axis(y_axis)

          x_axis = XAxis.new
          x_axis.set_stroke(1)
          x_axis.set_colour("#428c3e")
          x_axis.set_tick_height(5)
          x_axis.set_grid_colour('#86BF83')
          x_axis.set_steps(1)

          labels = XAxisLabels.new
          labels.set_steps(2)
          labels.set_vertical
          labels.set_colour('#ff0000')
          labels.set_size(16)
          tmp = []
          tmp << 'one'
          tmp << 'two'
          tmp << 'three'
          tmp << 'four'
          tmp << 'five'

          tmp << XAxisLabel.new("six", "#0000ff", 30, 270)
          tmp << XAxisLabel.new("seven", "#0000ff", 30, 270)
          eight = XAxisLabel.new("eight", "#8c773e", 16, 315)
          eight.set_visible
          tmp << eight

          tmp << XAxisLabel.new("nine", "#2683cf", 16, 0)

          #labels.set_labels tmp
          labels.set_labels(keys)
          x_axis.set_labels labels
          c.set_x_axis x_axis

        end

        puts '====================================='
        puts chart.to_s
        render :text => chart.to_s, :layout => false
      }
    end
  end

  def histroy
    respond_to do |wants|
      wants.html {
        @wttm_graph = open_flash_chart_object(600, 300, url_for(:action => 'histroy', :format => :json))
        @sttm_graph = open_flash_chart_object(600, 300, url_for(:action => 'show_sttm', :format => :json))
        @wmrq_graph = open_flash_chart_object(600, 300, url_for(:action => 'show_wmrq', :format => :json))
        @smrq_graph = open_flash_chart_object(600, 300, url_for(:action => 'show_smrq', :format => :json))
      }
      wants.json {
        chart = OpenFlashChart.new() do |c|
          values = []
          #sttm_values = []
          keys = []
          ttms = BlockTtm.find_all_by_stock_category_id(params[:id])
          ttms.each do |ttm|
            fttm = ttm.ttm.to_f
            #fsttm = ttm.sttm.to_f
            if fttm <0.01 && fttm > -0.01
              values << nil
            else
              values << fttm
            end

            keys << ttm.day
          end
          title = Title.new()
          title.text = StockCategory.find(params[:id]).name
          title.style = "{font-size: 30px;color: #ff00ff; font-family: Verdana; text-align: center;}"
          c.title = title

          hol = HollowDot.new
          hol.size = 3
          hol.halo_size = 1
          hol.set_tooltip('#x_label#<br>#val#')

          line = Line.new()
          line.text = 'ttm'
          line.set_default_dot_style(hol)
          line.set_values values

          c << line


          tmp = values.dup
          tmp.delete(nil)
          puts "values:"
          puts values
          puts "tmp:"
          puts tmp
          min = tmp.inject { |m, x| m = m < x ? m : x }
          max = tmp.inject { |m, x| m = m > x ? m : x }

          y_axis = YAxis.new
          y_axis.set_min min
          y_axis.set_max max
          y_axis.set_steps((max-min)/10)
          c.set_y_axis(y_axis)

          x_axis = XAxis.new
          x_axis.set_stroke(1)
          x_axis.set_colour("#428c3e")
          x_axis.set_tick_height(5)
          x_axis.set_grid_colour('#86BF83')
          x_axis.set_steps(1)

          labels = XAxisLabels.new
          labels.set_steps(2)
          labels.set_vertical
          labels.set_colour('#ff0000')
          labels.set_size(16)
          tmp = []
          tmp << 'one'
          tmp << 'two'
          tmp << 'three'
          tmp << 'four'
          tmp << 'five'

          tmp << XAxisLabel.new("six", "#0000ff", 30, 270)
          tmp << XAxisLabel.new("seven", "#0000ff", 30, 270)
          eight = XAxisLabel.new("eight", "#8c773e", 16, 315)
          eight.set_visible
          tmp << eight

          tmp << XAxisLabel.new("nine", "#2683cf", 16, 0)

          #labels.set_labels tmp
          labels.set_labels(keys)
          x_axis.set_labels labels
          c.set_x_axis x_axis

        end

        puts '====================================='
        puts chart.to_s
        json_txt = %!{ "elements": [ { "type": "line", "values": [ 5, 5, 5, 5, 5, 6, 5, 5, 4, 6 ], "dot-style": { "type": "hollow-dot", "dot-size": 3, "halo-size": 1, "tip": "#x_label#
#val#" } } ], "title": { "text": "X Axis Labels Complex Example" }, "x_axis": { "stroke": 1, "colour": "#428C3E", "tick-height": 5, "grid-colour": "#86BF83", "steps": 1, "labels": { "steps": 2, "rotate": 270, "colour": "#ff0000", "size": 16, "labels": [ "one", "two", "three", "four", "five", { "text": "six", "colour": "#0000FF", "size": 30, "rotate": 270 }, { "text": "seven", "colour": "#0000FF", "size": 30, "rotate": 270 }, { "text": "eight", "colour": "#8C773E", "size": 16, "rotate": 315, "visible": true }, { "text": "nine", "colour": "#2683CF", "size": 16, "rotate": 0 } ] } } }!
        render :text => chart.to_s, :layout => false
      }
    end
=begin
    @graph = open_flash_chart_object(600,300, "/block_ttms/#{params[:id]}/null_data")
    puts @graph
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @block_ttms }
    end
=end
  end

  def market_indicator
    respond_to do |wants|
      wants.html {
        @graph = open_flash_chart_object(600, 300, url_for(:action => 'market_indicator', :format => :json))
      }
      wants.json {
        chart = OpenFlashChart.new() do |c|
          values = []
          sttm_values = []
          keys = []
          ttms = BlockTtm.find_all_by_stock_category_id(params[:id])
          ttms.each do |ttm|
            fttm = ttm.ttm.to_f
            fsttm = ttm.sttm.to_f
            if fttm <0.01 && fttm > -0.01
              values << nil
            else
              values << fttm
            end

            if fsttm <0.01 && fsttm > -0.01
              sttm_values << nil
            else
              sttm_values << fsttm
            end

            keys << ttm.day
          end
          title = Title.new()
          title.text = StockCategory.find(params[:id]).name
          title.style = "{font-size: 30px;color: #ff00ff; font-family: Verdana; text-align: center;}"
          c.title = title

          hol = HollowDot.new
          hol.size = 3
          hol.halo_size = 1
          hol.set_tooltip('#x_label#<br>#val#')

          line = Line.new()
          line.text = 'ttm'
          line.set_default_dot_style(hol)
          line.set_values values

          c << line

          sttm_line = Line.new
          sttm_line.text = 'sttm'
          sttm_line.colour = '#ff0000'
          sttm_line.set_default_dot_style(hol)
          sttm_line.set_values sttm_values
          c << sttm_line

          tmp = values.dup
          tmp.delete(nil)
          puts "values:"
          puts values
          puts "tmp:"
          puts tmp
          min = tmp.inject { |m, x| m = m < x ? m : x }
          max = tmp.inject { |m, x| m = m > x ? m : x }
          tmp = sttm_values.dup
          tmp.delete(nil)
          puts ""
          puts "sttm_values:"
          puts sttm_values
          puts "tmp:"
          puts tmp
          min = tmp.inject(min) { |m, x| m = m < x ? m : x }
          max = tmp.inject(max) { |m, x| m = m > x ? m : x }

          y_axis = YAxis.new
          y_axis.set_min min
          y_axis.set_max max
          y_axis.set_steps((max-min)/10)
          c.set_y_axis(y_axis)

          x_axis = XAxis.new
          x_axis.set_stroke(1)
          x_axis.set_colour("#428c3e")
          x_axis.set_tick_height(5)
          x_axis.set_grid_colour('#86BF83')
          x_axis.set_steps(1)

          labels = XAxisLabels.new
          labels.set_steps(2)
          labels.set_vertical
          labels.set_colour('#ff0000')
          labels.set_size(16)
          tmp = []
          tmp << 'one'
          tmp << 'two'
          tmp << 'three'
          tmp << 'four'
          tmp << 'five'

          tmp << XAxisLabel.new("six", "#0000ff", 30, 270)
          tmp << XAxisLabel.new("seven", "#0000ff", 30, 270)
          eight = XAxisLabel.new("eight", "#8c773e", 16, 315)
          eight.set_visible
          tmp << eight

          tmp << XAxisLabel.new("nine", "#2683cf", 16, 0)

          #labels.set_labels tmp
          labels.set_labels(keys)
          x_axis.set_labels labels
          c.set_x_axis x_axis

        end
=begin
        chart = OpenFlashChart.new() do  |c|
          values = []
          sttm_values = []
          keys = [ ]
          ttms = BlockTtm.find_all_by_stock_category_id(params[:id])
          ttms.each do |ttm|
            values << ttm.ttm.to_f
            sttm_values << ttm.sttm.to_f
            keys << ttm.day
          end

          #c.set_data(values)
          #c.set_data(sttm_values)
          line1 = Line.new
          line1.set_text('ttm')
          line1.set_data values
          c << line1

          line2 = LineDot.new
          line2.set_text('sttm')
          line2.set_data sttm_values
          c << line2

          c.set_x_labels keys
          c.set_x_label_style(10,'0x000000',0,2)

          c.set_y_max(50)
          c.set_y_label_steps 4

        end
=end
        puts '====================================='
        puts chart.to_s
        json_txt = %!{ "elements": [ { "type": "line", "values": [ 5, 5, 5, 5, 5, 6, 5, 5, 4, 6 ], "dot-style": { "type": "hollow-dot", "dot-size": 3, "halo-size": 1, "tip": "#x_label#
#val#" } } ], "title": { "text": "X Axis Labels Complex Example" }, "x_axis": { "stroke": 1, "colour": "#428C3E", "tick-height": 5, "grid-colour": "#86BF83", "steps": 1, "labels": { "steps": 2, "rotate": 270, "colour": "#ff0000", "size": 16, "labels": [ "one", "two", "three", "four", "five", { "text": "six", "colour": "#0000FF", "size": 30, "rotate": 270 }, { "text": "seven", "colour": "#0000FF", "size": 30, "rotate": 270 }, { "text": "eight", "colour": "#8C773E", "size": 16, "rotate": 315, "visible": true }, { "text": "nine", "colour": "#2683CF", "size": 16, "rotate": 0 } ] } } }!
        render :text => chart.to_s, :layout => false
      }
    end
=begin
    @graph = open_flash_chart_object(600,300, "/block_ttms/#{params[:id]}/null_data")
    puts @graph
    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @block_ttms }
    end
=end
  end
end

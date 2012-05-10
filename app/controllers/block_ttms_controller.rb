require 'windin_client'
class BlockTtmsController < ApplicationController
  # GET /block_ttms
  # GET /block_ttms.xml
  def index
    @block_ttms = BlockTtm.find_all_by_day( BlockTtm.order("day desc").limit(1).first.day )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @block_ttms }
    end
  end

  # GET /block_ttms/1
  # GET /block_ttms/1.xml
  def show
    @block_ttm = BlockTtm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @block_ttm }
    end
  end

  # GET /block_ttms/new
  # GET /block_ttms/new.xml
  def new
    @block_ttm = BlockTtm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @block_ttm }
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
        format.xml  { render :xml => @block_ttm, :status => :created, :location => @block_ttm }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @block_ttm.errors, :status => :unprocessable_entity }
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
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @block_ttm.errors, :status => :unprocessable_entity }
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
      format.xml  { head :ok }
    end
  end

  def histroy
    respond_to do |wants|
      wants.html {
        @graph = open_flash_chart_object( 600, 300, url_for( :action => 'histroy', :format => :json ) )
      }
      wants.json {
        chart = OpenFlashChart.new( "ttms info" ) do |c|
          #c << BarGlass.new( :values => (1..10).sort_by{rand} )
          #c << Line.new(:values => [10,11,12])
          values = []
          keys = [ ]
          ttms = BlockTtm.find_all_by_stock_category_id(params[:id])
          ttms.each do |ttm|
            values << ttm.ttm.to_f
            keys << ttm.day
          end
          title = Title.new('X Axis Labels Complex Example' )
          hol = HollowDot.new
          hol.size = 3
          hol.halo_size = 1
          hol.set_tooltip('#x_label#<br>#val#')
          line = Line.new()
          line.text = 'ttm'
          line.set_default_dot_style(hol)
          line.set_values values
          c << line
          min = values.inject {|m,x| m = m < x ? m : x }
          max = values.inject {|m,x| m = m > x ? m : x }
          y_axis = YAxis.new
          y_axis.set_min  min
          y_axis.set_max  max
          y_axis.set_steps(  (max-min)/10 )
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

          tmp << XAxisLabel.new("six","#0000ff",30,270)
          tmp << XAxisLabel.new("seven","#0000ff",30,270)
          eight = XAxisLabel.new("eight","#8c773e",16,315)
          eight.set_visible
          tmp << eight

          tmp << XAxisLabel.new("nine","#2683cf",16,0)

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

def null_data
    data1 = []
    data2 = []
    year = Time.now.year

    ttms = BlockTtm.find_all_by_stock_category_id(params[:id])
=begin
    31.times do |i|
      x = "#{year}-1-#{i+1}".to_time.to_i
      y = (Math.sin(i+1) * 2.5) + 10

      data1 << ScatterValue.new(x,y)
      data2 << (Math.cos(i+1) * 1.9) + 4
    end
=end
    ttms.each do |elm|
      data1 << ScatterValue.new(elm.day,elm.ttm)
    end
    data2 = data1

    dot = HollowDot.new
    dot.size = 3
    dot.halo_size = 2
    dot.tooltip = "Value: #val#"

    line = ScatterLine.new("#DB1750", 3)
    line.values = data1
    line.default_dot_style = dot

    x = XAxis.new
    #x.set_range("#{year}-1-1".to_time.to_i, "#{year}-1-31".to_time.to_i)
    #x.steps = 86400

    labels = XAxisLabels.new
    labels.text = "#date: l jS, M Y#"
    #labels.steps = 86400
    #labels.visible_steps = 2
    labels.rotate = 90

    x.labels = labels

    y = YAxis.new
    y.set_range(0,15,5)

    chart = OpenFlashChart.new
    title = Title.new(data2.size)

    chart.title = title
    chart.add_element(line)
    chart.x_axis = x
    chart.y_axis = y

    render :text => chart, :layout => false
  end



=begin
  #----------------------------------------------------------------
  def null_data
    puts '================================================='
    puts 'in null_data...'
    g = OpenFlashChart.new
    g.set_x_label_style(10, '#9933CC')
    g.set_y_label_steps(8)

    g.set_y_min(0)
    g.set_y_max(40000)

    dates = (Date.civil(2007,2,19) .. Date.civil(2007,3,4)).map(&:to_s)

    g.set_x_labels(dates)

    data = []
    dates.size.times do |x|
      if x.modulo(3) == rand(3)
        data << 'null'
      else
        data << rand(40000)
      end
    end

    g.set_data(data)
    #g.line_hollow(2, 4, '0x80a033', 'Bounces', 10)

    g.set_x_label_style( 10, '#CC3399', 2 );

    g.set_title("Null Data Example", '{font-size: 14px; color: #CC3399}')
    g.set_tool_tip("#val#")

    render :text => g.to_s
  end
=end
  def graph_code
    # based on this example - http://teethgrinder.co.uk/open-flash-chart-2/pie-chart.php
    title = Title.new("Pie Chart Example For Chipster")

    pie = Pie.new
    pie.start_angle = 35
    pie.animate = true
    pie.tooltip = '#val# of #total#<br>#percent# of 100%'
    pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
    pie.values = [PieValue.new(2,"Chinese"), PieValue.new(3,"cc"), PieValue.new(6.5, "Hello (6.5)")]

    chart = OpenFlashChart.new
    chart.title = title
    chart.add_element(pie)

    chart.x_axis = nil

    render :text => chart.to_s
  end

end

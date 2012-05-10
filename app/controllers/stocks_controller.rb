require 'indicators/nhnl'
class StocksController < ApplicationController
  # GET /stocks
  # GET /stocks.xml
  def index
    #view
    puts "in index now..."
    @stocks = Stock.where(:market=>[0,1]).paginate :page => params[:page], :order => 'market,code', :per_page => 20
    #Nhnl.dump
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stocks }
    end
  end

  # GET /stocks/1
  # GET /stocks/1.xml
  def show
    @stock = Stock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock }
    end
  end

  # GET /stocks/new
  # GET /stocks/new.xml
  def new
    @stock = Stock.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock }
    end
  end

  # GET /stocks/1/edit
  def edit
    @stock = Stock.find(params[:id])
  end

  # POST /stocks
  # POST /stocks.xml
  def create
    @stock = Stock.new(params[:stock])

    respond_to do |format|
      if @stock.save
        format.html { redirect_to(@stock, :notice => 'Stock was successfully created.') }
        format.xml  { render :xml => @stock, :status => :created, :location => @stock }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stocks/1
  # PUT /stocks/1.xml
  def update
    @stock = Stock.find(params[:id])

    respond_to do |format|
      if @stock.update_attributes(params[:stock])
        format.html { redirect_to(@stock, :notice => 'Stock was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.xml
  def destroy
    @stock = Stock.find(params[:id])
    @stock.destroy

    respond_to do |format|
      format.html { redirect_to(stocks_url) }
      format.xml  { head :ok }
    end
  end

  #-----------------------test open flash chart ----------------------------------------------
  def view
    @graph = open_flash_chart_object(500,250, '/projects/open_flash_chart_plugin/candle', true, '/projects/')
  end

  def candle
    a = []
    b = []

    labels = %w(Mon Tue Wed Thu Fri)

    a << Candle.new(10,8,6,4)
    b << Candle.new(10,8,6,4)
    a << Candle.new(20,15,10,5)
    b << Candle.new(20,10,15,5)
    a << Candle.new(20,15,10,5)
    b << Candle.new(28,24,18,16)
    a << Candle.new(20,10,15,5)
    b << Candle.new(10,6,9,4)
    a << Candle.new(30,5,27,2)
    b << Candle.new(5,4,2,1)

    g = Graph.new
    g.title("Candle", '{font-size:26px;}')
    g.candle(a, 60, 2, '#c11b01', 'My Company', 12)
    g.candle(b, 60, 2, '#b0c101', 'Your Company', 12)

    g.set_tool_tip('#x_legend#<br>High: #high#<br>Open: #open#<br>Close: #close#<br>Low: #low#' )
    g.set_x_labels(labels)

    g.set_x_label_style( 10, '#000000', 0, 1 );
    g.set_x_legend( 'Week 1', 12, '#C11B01' );

    g.set_y_min( 0 );
    g.set_y_max( 30 );

    g.set_y_label_steps( 10 );
    g.set_y_legend( 'Value', 12, '#C11B01' );
    render :text => g.render
  end

end

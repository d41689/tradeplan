class StockSignalsController < ApplicationController
  # GET /stock_signals
  # GET /stock_signals.xml
  def index
    @stock_signals = StockSignal.paginate :page => params[:page], :order => 'buy_date DESC', :per_page => 20

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_signals }
    end
  end

  # GET /stock_signals/1
  # GET /stock_signals/1.xml
  def show
    @stock_signal = StockSignal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_signal }
    end
  end

  # GET /stock_signals/new
  # GET /stock_signals/new.xml
  def new
    @stock_signal = StockSignal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_signal }
    end
  end

  # GET /stock_signals/1/edit
  def edit
    @stock_signal = StockSignal.find(params[:id])
  end

  # POST /stock_signals
  # POST /stock_signals.xml
  def create
    @stock_signal = StockSignal.new(params[:stock_signal])

    respond_to do |format|
      if @stock_signal.save
        format.html { redirect_to(@stock_signal, :notice => 'Stock signal was successfully created.') }
        format.xml  { render :xml => @stock_signal, :status => :created, :location => @stock_signal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stock_signal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stock_signals/1
  # PUT /stock_signals/1.xml
  def update
    @stock_signal = StockSignal.find(params[:id])

    respond_to do |format|
      if @stock_signal.update_attributes(params[:stock_signal])
        format.html { redirect_to(@stock_signal, :notice => 'Stock signal was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_signal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_signals/1
  # DELETE /stock_signals/1.xml
  def destroy
    @stock_signal = StockSignal.find(params[:id])
    @stock_signal.destroy

    respond_to do |format|
      format.html { redirect_to(stock_signals_url) }
      format.xml  { head :ok }
    end
  end
end

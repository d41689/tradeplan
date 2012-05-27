class StockFinancialDataController < ApplicationController
  # GET /stock_financial_data
  # GET /stock_financial_data.xml
  def index
    #@stock_financial_data = StockFinancialDatum.all
    @stock_financial_datum = StockFinancialDatum.new
    last_day = StockFinancialDatum.last.day
    @stock_financial_data = StockFinancialDatum.where("day = '#{last_day}' AND pe_ttm BETWEEN 0 AND 200 and mrq BETWEEN 0 AND 5 and mgjzc > 0 and jzcsyl_ttm > 10 AND mll_ttm > 20").order("pe_ttm asc,mrq asc,jzcsyl_ttm desc,mll_ttm desc").paginate :page => params[:page], :order => 'day desc', :per_page => 20

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @stock_financial_data }
    end
  end

  # GET /stock_financial_data/1
  # GET /stock_financial_data/1.xml
  def show
    @stock_financial_datum = StockFinancialDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @stock_financial_datum }
    end
  end

  # GET /stock_financial_data/new
  # GET /stock_financial_data/new.xml
  def new
    @stock_financial_datum = StockFinancialDatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @stock_financial_datum }
    end
  end

  # GET /stock_financial_data/1/edit
  def edit
    @stock_financial_datum = StockFinancialDatum.find(params[:id])
  end

  # POST /stock_financial_data
  # POST /stock_financial_data.xml
  def create
    @stock_financial_datum = StockFinancialDatum.new(params[:stock_financial_datum])

    respond_to do |format|
      if @stock_financial_datum.save
        format.html { redirect_to(@stock_financial_datum, :notice => 'Stock financial datum was successfully created.') }
        format.xml { render :xml => @stock_financial_datum, :status => :created, :location => @stock_financial_datum }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @stock_financial_datum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stock_financial_data/1
  # PUT /stock_financial_data/1.xml
  def update
    @stock_financial_datum = StockFinancialDatum.find(params[:id])

    respond_to do |format|
      if @stock_financial_datum.update_attributes(params[:stock_financial_datum])
        format.html { redirect_to(@stock_financial_datum, :notice => 'Stock financial datum was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @stock_financial_datum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_financial_data/1
  # DELETE /stock_financial_data/1.xml
  def destroy
    @stock_financial_datum = StockFinancialDatum.find(params[:id])
    @stock_financial_datum.destroy

    respond_to do |format|
      format.html { redirect_to(stock_financial_data_url) }
      format.xml { head :ok }
    end
  end
end

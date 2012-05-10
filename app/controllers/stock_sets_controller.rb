class StockSetsController < ApplicationController
  # GET /stock_sets
  # GET /stock_sets.xml
  def index
    #@stock_sets = StockSet.all
    @stock_sets = StockCategory.find(87).stock_sets

    @stock_sets.uniq!

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_sets }
    end
  end

  # GET /stock_sets/1
  # GET /stock_sets/1.xml
  def show
    @stock_set = StockSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_set }
    end
  end

  # GET /stock_sets/new
  # GET /stock_sets/new.xml
  def new
    @stock_set = StockSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_set }
    end
  end

  # GET /stock_sets/1/edit
  def edit
    @stock_set = StockSet.find(params[:id])
  end

  # POST /stock_sets
  # POST /stock_sets.xml
  def create
    @stock_set = StockSet.new(params[:stock_set])

    respond_to do |format|
      if @stock_set.save
        format.html { redirect_to(@stock_set, :notice => 'Stock set was successfully created.') }
        format.xml  { render :xml => @stock_set, :status => :created, :location => @stock_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stock_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stock_sets/1
  # PUT /stock_sets/1.xml
  def update
    @stock_set = StockSet.find(params[:id])

    respond_to do |format|
      if @stock_set.update_attributes(params[:stock_set])
        format.html { redirect_to(@stock_set, :notice => 'Stock set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_sets/1
  # DELETE /stock_sets/1.xml
  def destroy
    @stock_set = StockSet.find(params[:id])
    @stock_set.destroy

    respond_to do |format|
      format.html { redirect_to(stock_sets_url) }
      format.xml  { head :ok }
    end
  end
end

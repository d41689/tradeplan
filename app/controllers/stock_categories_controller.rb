require 'net/http'
require 'uri'
#require 'win32ole'
require 'win32ole'

class StockCategoriesController < ApplicationController
  # GET /stock_categories
  # GET /stock_categories.xml
  def index
    @stock_categories = StockCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @stock_categories }
    end
  end

  # GET /stock_categories/1
  # GET /stock_categories/1.xml
  def show

    @stock_category = StockCategory.find(params[:id])
    stock_ids = @stock_category.stock_sets.map { |stock_set| stock_set.stock_id }
    @stocks = Stock.find(stock_ids)

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @stock_category }
    end
  end

  # GET /stock_categories/new
  # GET /stock_categories/new.xml
  def new
    @stock_category = StockCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @stock_category }
    end
  end

  # GET /stock_categories/1/edit
  def edit
    @stock_category = StockCategory.find(params[:id])
  end

  # POST /stock_categories
  # POST /stock_categories.xml
  def create
    @stock_category = StockCategory.new(params[:stock_category])

    respond_to do |format|
      if @stock_category.save
        format.html { redirect_to(@stock_category, :notice => 'Stock category was successfully created.') }
        format.xml { render :xml => @stock_category, :status => :created, :location => @stock_category }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @stock_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stock_categories/1
  # PUT /stock_categories/1.xml
  def update
    @stock_category = StockCategory.find(params[:id])

    respond_to do |format|
      if @stock_category.update_attributes(params[:stock_category])
        format.html { redirect_to(@stock_category, :notice => 'Stock category was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @stock_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_categories/1
  # DELETE /stock_categories/1.xml
  def destroy
    @stock_category = StockCategory.find(params[:id])
    @stock_category.destroy

    respond_to do |format|
      format.html { redirect_to(stock_categories_url) }
      format.xml { head :ok }
    end
  end
end

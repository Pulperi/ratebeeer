class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy, :toggle_activity]
  before_action :ensure_that_signed_in, except: [:index, :show, :destroy, :nglist]
  before_action :ensure_that_admin, only: [:destroy]

  # GET /breweries
  # GET /breweries.json
  def index
    @order = params[:order] || 'name'
    @sort = params[:sort] || 'asc'

    session[:breweries_next_sort] = @sort == 'asc' ? 'desc' : 'asc'

    case @order
      when 'name' then
        @active_breweries = Brewery.active.order(name: @sort)
        @retired_breweries = Brewery.retired.order(name: @sort)
      when 'year' then
        @active_breweries = Brewery.active.order(year: @sort)
        @retired_breweries = Brewery.retired.order(year: @sort)
    end

  end

  def nglist
  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        clear_brewery_list
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        clear_brewery_list
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_activity
    clear_brewery_list
    @brewery.update_attribute :active, (not @brewery.active)
    new_status = @brewery.active? ? 'active' : 'retired'
    redirect_to :back, notice:"brewery activity status changed to #{new_status}"
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    clear_brewery_list
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      begin
        @brewery = Brewery.find(params[:id])
      rescue => ex
        logger.error ex.message
        redirect_to breweries_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

    def clear_brewery_list
      %w(brewerieslist-year-desc brewerieslist-year-asc brewerieslist-name-desc brewerieslist-name-asc).each {|f| expire_fragment(f)  }
    end
end

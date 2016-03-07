class BeersController < ApplicationController
  before_action :skip_if_cached, only:[:index]
  before_action :set_beer, only: [:show, :edit, :update, :destroy]
  before_action :set_helpers, only: [:new, :edit, :create]
  before_action :ensure_that_signed_in, except: [:index, :show, :destroy, :list, :nglist]
  before_action :ensure_that_admin, only: [:destroy]

  # GET /beers
  # GET /beers.json
  def index
    order = params[:order] || 'name'
    @beers = case order
               when 'name' then Beer.includes([:brewery, :style]).order(:name)
               when 'brewery' then Beer.includes([:brewery, :style]).order('breweries.name')
               when 'style' then Beer.includes([:brewery, :style]).order('styles.name')
             end
  end

  def list

  end

  def nglist

  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  # GET /beers/new
  def new
    @beer = Beer.new
  end

  # GET /beers/1/edit
  def edit
  end

  # POST /beers
  # POST /beers.json
  def create
    @beer = Beer.new(beer_params)
    respond_to do |format|
      if @beer.save
        clear_beerlist
        format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }
        format.json { render :show, status: :created, location: @beer }
      else
        format.html { render :new }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        clear_beerlist
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    clear_beerlist
    @beer.destroy
    respond_to do |format|
      format.html { redirect_to beers_url, notice: 'Beer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])
    end

    def set_helpers
      @breweries = Brewery.all
      @styles = Style.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_params
      params.require(:beer).permit(:name, :style_id, :brewery_id)
    end

  def skip_if_cached
    @order = params[:order] || 'name'
    return render :index if fragment_exist?( "beerlist-#{@order}"  )
  end

  def clear_beerlist
    ['beerlist-name', 'beerlist-brewery', 'beerlist-style'].each {|f| expire_fragment(f) }
  end

end

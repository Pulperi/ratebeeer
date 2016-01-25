class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    render :index
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new(rating_params)
    @rating.save
    redirect_to ratings_path
  end

  def destroy
    @rating = Rating.find_by id:params[:id]
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to ratings_url, notice: 'Rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def rating_params
    params.require(:rating).permit(:beer_id, :score)
  end
end
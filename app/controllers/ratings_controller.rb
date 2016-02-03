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
    if @rating.save
      current_user.ratings << @rating
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find_by id:params[:id]
    rating.destroy if current_user == rating.user
    redirect_to :back
  end

  private
  def rating_params
    params.require(:rating).permit(:beer_id, :score)
  end
end
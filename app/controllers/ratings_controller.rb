class RatingsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index]
  before_action :skip_if_cached, only:[:index]

  def index
    @recent_ratings = Rating.recent(5).includes([{ beer: :brewery }, :user])
    @most_active_users = User.top(5)
    @best_beers = Beer.top(3)
    @best_breweries = Brewery.top(3)
    @best_styles = Style.top(3)
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

  def skip_if_cached
    return render :index if fragment_exist?('ratings-stats')
  end
end
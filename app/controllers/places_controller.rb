class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:last_search] = params[:city].downcase
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def show
    @place = find_by_id_from_last_search(params[:id])
  end

  def find_by_id_from_last_search(id)
    places = Rails.cache.read session[:last_search]
    places.each do |place|
      if place.id == id
        return place
      end
    end
    return null
  end
end
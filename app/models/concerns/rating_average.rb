module RatingAverage
  extend ActiveSupport::Concern
  def average_rating
    ratings.map{|rating| rating.score}.inject(:+).to_f/ratings.count
  end
end
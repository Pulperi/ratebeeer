module RatingAverage
  extend ActiveSupport::Concern
  def average_rating
    ratings.empty? ? 0 : ratings.map{|rating| rating.score}.sum.to_f/ratings.count
  end
end
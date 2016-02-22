class Style < ActiveRecord::Base
  include RatingAverage

  validates :desc, uniqueness: false
  validates :name, uniqueness: true
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating||0) }
    sorted_by_rating_in_desc_order.take(n)
  end

  def to_s
    name
  end
end

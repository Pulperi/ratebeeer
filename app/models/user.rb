class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3 }
  validate :password, :is_valid_password

  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy

  has_many :beer_clubs, through: :memberships
  has_many :beers, through: :ratings

  def is_valid_password
    min_pass_length = 4
    if not password.nil?
      if password.length < min_pass_length
        errors.add(:password, "is too short (minimum is #{min_pass_length} characters)")
      elsif /[A-Z]/.match(password).nil? || /[0-9]/.match(password).nil?
        errors.add(:password, 'has to contain at least one number and uppercase character.')
      end
    end
  end

  def favorite_beer
    return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(category)
    return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole
    items_with_average_ratings(category).max_by {|k, v| v}.first
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |u| - (u.ratings.count ||0) }
    sorted_by_rating_in_desc_order.take(n)
  end

  # Helper methods

  def items_with_average_ratings (category)
    hash = ratings.group_by { |r| r.beer.send(category) }
    hash.update(hash) { |k, v| v.map{ |r| r.score }.sum.to_f/v.count }
  end
end

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
end

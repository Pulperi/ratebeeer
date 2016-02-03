class Brewery < ActiveRecord::Base
  include RatingAverage
  require 'date'

  validate :year, :validate_found_year
  validates :name, uniqueness: false, length: { minimum: 1 }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def validate_found_year
    if year.nil? or not year.integer?
      errors.add(:year, "is not a number.")
    else
      if year < 1042
        errors.add(:year, "has to be greater or equal to 1042.")
      end
      if year > Date.today.year
        errors.add(:year, "cannot be in the future.")
      end
    end
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2016
    puts "changed year to #{year}"
  end

end

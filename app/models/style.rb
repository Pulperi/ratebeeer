class Style < ActiveRecord::Base
  validates :desc, uniqueness: false
  validates :name, uniqueness: true
  has_many :beers, dependent: :destroy

  def to_s
    name
  end
end

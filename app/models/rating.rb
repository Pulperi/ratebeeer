class Rating < ActiveRecord::Base
  belongs_to :beer, touch: true
  belongs_to :user

  validates :score, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 50, only_integer: true}
  scope :recent, -> (limit) { order(created_at: :desc).limit(limit) }

  def to_s
    "#{beer.name} #{score}"
  end
end

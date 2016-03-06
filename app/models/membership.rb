class Membership < ActiveRecord::Base

  validate :beer_club_id, :not_a_duplicate, on: :create

  belongs_to :beer_club
  belongs_to :user

  def not_a_duplicate
    if not Membership.where(:user_id => user_id, :beer_club_id => beer_club_id).empty?
      errors.add(:beer_club_id, "- You are already member of this club")
    end
  end

end

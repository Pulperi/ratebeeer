class AddUserIdToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :user_id, :integer
    add_column :memberships, :beer_club_id, :integer
  end
end

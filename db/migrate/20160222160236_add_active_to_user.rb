class AddActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :deactive, :boolean
  end
end

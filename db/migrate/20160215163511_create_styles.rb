class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.text :name
      t.text :desc
      t.timestamps null: false
    end
  end
end

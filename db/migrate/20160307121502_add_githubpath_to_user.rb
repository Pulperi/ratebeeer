class AddGithubpathToUser < ActiveRecord::Migration
  def change
    add_column :users, :githubpath, :string
  end
end

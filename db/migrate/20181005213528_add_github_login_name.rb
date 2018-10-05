class AddGithubLoginName < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_login, :string
  end
end

class AddGithubLoginName < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_login, :string
    add_column :users, :token, :string
  end
end

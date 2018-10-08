require 'octokit'

class  DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_name = current_user.github_login
    @gists = Octokit.gists(@user_name)
  end

  def show_gist
    @gist = Octokit.gist(params[:id])
  end
end

class  DashboardController < ApplicationController
  include DashboardHelper
  before_action :authenticate_user!

  def index
    @following = current_client.following
    @followers = current_client.followers
  end

  def get_follower_gists
    @owner = params[:login]
    starred_gist_ids = current_client.starred_gists.pluck(:id)
    @gists = Octokit.gists(@owner).each do |gist|
      gist[:starred] = starred_gist_ids.include?(gist.id)
    end
  end

  def gist_content
    @gist = Octokit.gist(params[:id])
    respond_to do |format|
      format.html { redirect_to @gist.url }
      format.js
    end
  end

  def star_gist
    gist_action("star")
  end

  def unstar_gist
    gist_action("unstar")
  end
end

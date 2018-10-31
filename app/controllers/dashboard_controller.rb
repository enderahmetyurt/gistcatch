class  DashboardController < ApplicationController
  include DashboardHelper
  before_action :authenticate_user!

  def index
    @following = current_client.following
    @followers = current_client.followers
  end

  def get_gists
    @owner = params[:login]
    starred_gist_ids = current_client.starred_gists.pluck(:id)
    @gists = Octokit.gists(@owner).each do |gist|
      gist[:starred] = starred_gist_ids.include?(gist.id)
    end

    @gists = @gists.partition { |v| v.starred == true }.flatten
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

  def delete_gist
    gist_action("delete")
  end

  def new_gist
    @gist = Gist.new
    @gist.build_file
  end

  def create_gist
    @gist = Gist.new create_gist_params

    if @gist.valid?
      resource_response = current_client.create_gist @gist.create_payload

      if current_client.last_response.status == 201
        flash[:success] = <<~TXT.squish
          The gist was successfully created at #{resource_response[:html_url]}
        TXT
        redirect_to root_path
      else
        flash[:danger] = "We couldn't create the gist."
        render :new_gist
      end
    else
      render :new_gist
    end
  end

  private

    def create_gist_params
      params.require(:gist).permit(
        :description,
        :public,
        files_attributes: %i[filename content]
      )
    end
end

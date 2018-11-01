class  DashboardController < ApplicationController
  include DashboardHelper
  before_action :authenticate_user!

  def index
    @following = current_client.following
    @followers = current_client.followers
  end

  def get_gists
    @owner = params[:login]

    @gists =
      if @owner == current_client.login
        case params[:filter]
        when "public"
          Octokit.gists(@owner)
        when "forked"
          current_client.gists.each do |gist|
            gist.forked = current_client.gist_forks(gist.id).any?
          end.select(&:forked)
        when "starred"
          current_client.starred_gists.each { |gist| gist.starred = true }
        else
          current_client.gists
        end
      else
        Octokit.gists(@owner)
      end

    @gists = star_starred_gists(@gists)
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

    def star_starred_gists(gists)
      current_client_starred_gist_ids = current_client.starred_gists.pluck(:id)

      gists.each do |gist|
        gist.starred = current_client_starred_gist_ids.include?(gist.id)
      end.partition(&:starred).flatten
    end
end

module DashboardHelper
  def stack
    Faraday::RackBuilder.new do |builder|
      builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
      builder.use Octokit::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end
  end

  def client
    Octokit.middleware = stack
    client = Octokit::Client.new(user: current_user.github_login, access_token: current_user.token)
    client.auto_paginate = true
    client
  end

  def current_client
    @current_client ||= client
  end

  def gist_action(action)
    respond_to do |format|
        format.html { redirect_to Octokit.gist(params[:id]).url }
        format.js {
          render json: { error: "Couldn't #{action} the gist" } unless current_client.send("#{action}_gist", params[:id])
        }
      end
  end
end

require "octokit"
require "faraday-http-cache"

class  DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    stack = Faraday::RackBuilder.new do |builder|
      builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
      builder.use Octokit::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end
    Octokit.middleware = stack

    client = Octokit::Client.new(user: current_user.github_login, access_token: current_user.token)
    client.auto_paginate = true
    @following = client.following
    @followers = client.followers
  end

  def get_follower_gists
    @owner = params[:login]
    @gists = Octokit.gists(@owner)
  end
end

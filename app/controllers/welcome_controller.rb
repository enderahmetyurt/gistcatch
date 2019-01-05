# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    redirect_to dashboard_index_path if user_signed_in?
  end
end

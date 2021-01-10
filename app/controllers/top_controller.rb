class TopController < ApplicationController
  skip_before_action :require_sign_in!, only: [:index]
  def index

  end
end

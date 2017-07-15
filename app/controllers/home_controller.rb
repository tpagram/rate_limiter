class HomeController < ApplicationController

  before_action only: :index do |c|
    c.rate_limit 100, 1.hour
  end

  def index
    head :ok, content_type: "text/html"
  end
end

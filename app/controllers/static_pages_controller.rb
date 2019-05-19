class StaticPagesController < ApplicationController
  def index
    @shows = Show.valid_shows
  end
end

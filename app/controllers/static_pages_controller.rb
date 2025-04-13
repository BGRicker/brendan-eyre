class StaticPagesController < ApplicationController
  layout 'static'

  def index
    @shows = Show.valid_shows
  end
end

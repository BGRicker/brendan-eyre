class StaticPagesController < ApplicationController
  def index
    @shows = Show.all
  end
end

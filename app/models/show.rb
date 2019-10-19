class Show < ApplicationRecord
  belongs_to :user

  attr_reader :formatted_date

  def formatted_date
    dates.to_date
  end
    self.future_shows.sort_by(&:formatted_date)
  end

  private

  def self.future_shows
    all.select { |show| show.formatted_date >= Date.current }
  end

  def self.past_shows
  end
end

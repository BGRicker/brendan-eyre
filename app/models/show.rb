class Show < ApplicationRecord
  belongs_to :user

  attr_reader :formatted_date

  def formatted_date
    dates.to_date
  end

  def self.valid_shows
    self.future_shows.sort_by(&:formatted_date)
  end

  private

  def self.future_shows
    all.select { |show| show.formatted_date >= Date.current }
  end

  def self.past_shows
    all.select { |show| show.formatted_date <= Date.current }
  end
end

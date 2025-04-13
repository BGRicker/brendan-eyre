class Show < ApplicationRecord
  belongs_to :user

  validates :dates, presence: true
  validates :venue, presence: true
  validates :location, presence: true

  attr_reader :formatted_date

  def formatted_date
    if dates.include?('-')
      array = dates.split
      dash_index = array.find_index('-')
      prior_date = dash_index - 1

      array.slice!(1..2)
      return array.join(' ').to_date
    end

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

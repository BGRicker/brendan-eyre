class Show < ApplicationRecord
  belongs_to :user

  validates :dates, presence: true
  validates :venue, presence: true
  validates :location, presence: true
  validate :valid_date_format

  attr_reader :formatted_date

  def formatted_date
    date = parse_date_string
    # If the date is in the past and no year was specified, adjust to next occurrence
    if date < Date.current && !dates.match?(/\d{4}/)
      date = date.next_year
    end
    date
  end

  def self.valid_shows
    self.future_shows.sort_by(&:formatted_date)
  end

  private

  def parse_date_string
    if dates.include?('-')
      # For ranges, use the first date for sorting/validation
      array = dates.split
      dash_index = array.find_index('-')
      first_date = array[0..dash_index-1].join(' ')
      return first_date.to_date
    end

    dates.to_date
  rescue Date::Error
    raise ArgumentError, "Invalid date format"
  end

  def valid_date_format
    begin
      parse_date_string
    rescue ArgumentError, Date::Error
      errors.add(:dates, "must be in a valid format (e.g., 'October 31' or 'October 25 - 31')")
    end
  end

  def self.future_shows
    all.select { |show| show.formatted_date >= Date.current }
  end

  def self.past_shows
    all.select { |show| show.formatted_date <= Date.current }
  end
end

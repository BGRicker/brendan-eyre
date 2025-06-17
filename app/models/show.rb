class Show < ApplicationRecord
  belongs_to :user

  validates :dates, presence: true
  validates :venue, presence: true
  validates :location, presence: true

  attr_reader :formatted_date

  def formatted_date
    return nil if dates.blank?
    
    # Remove any commas and clean up the string
    clean_dates = dates.gsub(',', '').strip
    
    if clean_dates.include?('-')
      # Split on the dash and take the first date
      start_date = clean_dates.split('-').first.strip
      parse_date(start_date)
    else
      parse_date(clean_dates)
    end
  end

  def start_date
    return nil if dates.blank?
    
    # Clean the date string
    clean_dates = dates.gsub(',', '').strip
    
    if clean_dates.include?('-')
      # Split on the dash and take the first date
      start_date = clean_dates.split('-').first.strip
      parse_date(start_date)
    else
      parse_date(clean_dates)
    end
  end

  def end_date
    return nil if dates.blank?
    
    # Clean the date string
    clean_dates = dates.gsub(',', '').strip
    
    if clean_dates.include?('-')
      # For ranges like "May 1-3 2025", get the end date
      parts = clean_dates.split('-')
      start_parts = parts.first.strip.split
      end_parts = parts.last.strip.split
      
      # If end part doesn't include month/year, use from start
      month = start_parts[0]
      year = (end_parts.last =~ /\d{4}/) ? end_parts.last : start_parts.last
      
      # Construct the full end date
      date_str = [month, end_parts.first, year].join(' ')
      parse_date(date_str)
    else
      parse_date(clean_dates)
    end
  end

  def self.valid_shows
    # Since shows won't overlap, sorting by start_date gives same order as end_date
    # Using start_date as it's more intuitive when reading the dates
    self.future_shows.sort_by { |show| show.start_date || Date.new(9999) }
  end

  private

  def parse_date(date_str)
    # Try to parse with year first
    Date.parse(date_str)
  rescue ArgumentError
    # If no year specified, assume current year
    Date.parse("#{date_str} #{Time.current.year}")
  rescue
    nil
  end

  def self.future_shows
    # Use end_date for determining if a show is in the future
    # This keeps shows visible until they're completely over
    # Handle nil dates gracefully by excluding them
    all.select { |show| show.end_date && show.end_date >= Date.current }
  end

  def self.past_shows
    # Handle nil dates gracefully by excluding them
    all.select { |show| show.end_date && show.end_date < Date.current }
  end
end

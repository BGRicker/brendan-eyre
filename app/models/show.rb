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
    
    clean_dates = dates.gsub(',', '').strip
    
    if clean_dates.include?('-')
      parts = clean_dates.split('-')
      start_parts = parts.first.strip.split
      end_parts = parts.last.strip.split
      
      # Check if the range has an explicit year
      if clean_dates.match(/\b\d{4}\b/)
        # Has explicit year, use the old logic
        month = start_parts[0]
        year = (end_parts.last =~ /\d{4}/) ? end_parts.last : start_parts.last
        
        # Construct the full end date
        date_str = [month, end_parts.first, year].join(' ')
        parse_date(date_str)
      else
        # No year specified, construct the end date and let parse_date handle the year logic
        month = start_parts[0]
        date_str = [month, end_parts.first].join(' ')
        parse_date(date_str)
      end
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
    # Check if the date string contains a 4-digit year
    if date_str.match(/\b\d{4}\b/)
      # Has explicit year, parse normally
      Date.parse(date_str)
    else
      # No year specified, assume the next occurrence of this date
      parsed_date = Date.parse("#{date_str} #{Date.current.year}")
      
      # If this date has already passed this year, assume next year
      if parsed_date < Date.current
        parsed_date = Date.parse("#{date_str} #{Date.current.year + 1}")
      end
      
      parsed_date
    end
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

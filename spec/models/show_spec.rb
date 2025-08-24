require 'rails_helper'

RSpec.describe Show, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe "#start_date" do
    let!(:show) { FactoryBot.create(:show, user: user, dates: "October 31 2025") }

    it "converts the date string to a Date object" do
      expect(show.start_date.class).to eq(Date)
    end
  end

  describe "#parse_date" do
    context "with full dates including year" do
      it "parses dates with explicit year" do
        show = FactoryBot.create(:show, user: user, dates: "December 25 2025")
        expect(show.start_date).to eq(Date.new(2025, 12, 25))
      end

      it "parses dates with different year formats" do
        show = FactoryBot.create(:show, user: user, dates: "Jan 15, 2026")
        expect(show.start_date).to eq(Date.new(2026, 1, 15))
      end
    end

    context "with year-less dates" do
      before do
        # Mock the current date to December 2025 for consistent testing
        travel_to Date.new(2025, 12, 20)
      end

      after do
        travel_back
      end

      it "assumes current year for future dates" do
        show = FactoryBot.create(:show, user: user, dates: "December 25")
        expect(show.start_date).to eq(Date.new(2025, 12, 25))
      end

      it "assumes next year for dates that have passed this year" do
        show = FactoryBot.create(:show, user: user, dates: "January 15")
        expect(show.start_date).to eq(Date.new(2026, 1, 15))
      end

      it "handles edge case around year boundary" do
        show = FactoryBot.create(:show, user: user, dates: "December 30")
        expect(show.start_date).to eq(Date.new(2025, 12, 30))
      end
    end

    context "with date ranges" do
      it "parses start date from range" do
        show = FactoryBot.create(:show, user: user, dates: "October 25 - 31 2025")
        expect(show.start_date).to eq(Date.new(2025, 10, 25))
      end

      it "parses end date from range" do
        show = FactoryBot.create(:show, user: user, dates: "October 25 - 31 2025")
        expect(show.end_date).to eq(Date.new(2025, 10, 31))
      end

      it "handles year-less ranges correctly" do
        travel_to Date.new(2025, 12, 20)
        
        show = FactoryBot.create(:show, user: user, dates: "January 15 - 20")
        expect(show.start_date).to eq(Date.new(2026, 1, 15))
        expect(show.end_date).to eq(Date.new(2026, 1, 20))
        
        travel_back
      end
    end
  end

  describe "#valid_shows" do
    context "with single dates" do
      let!(:show) { FactoryBot.create(:show, user: user, dates: "October 25 - 31 2025") }
      let!(:second_show) { FactoryBot.create(:show, user: user, dates: "November 12 - 15 2025") }
      let!(:third_show) { FactoryBot.create(:show, user: user, dates: "November 25 - 30 2025") }
      let!(:past_show) { FactoryBot.create(:show, user: user, dates: "January 1 2009") }

      it "shows only future dates ordered by start date" do
        expect(described_class.valid_shows).to eq([show, second_show, third_show])
        expect(described_class.valid_shows).not_to include(past_show)
      end
    end

    context "with range dates" do
      let!(:first_range_show) { FactoryBot.create(:show, user: user, dates: "October 25 - 31 2025") }
      let!(:second_range_show) { FactoryBot.create(:show, user: user, dates: "September 5 - 8 2025") }
      let!(:past_range_show) { FactoryBot.create(:show, user: user, dates: "January 25 - 29 2015") }

      it "shows only future dates ordered by start date" do
        expect(described_class.valid_shows).to eq([second_range_show, first_range_show]) # Sept 5 comes before Oct 25
        expect(described_class.valid_shows).not_to include(past_range_show)
      end
    end

    context "with year boundary dates" do
      before do
        travel_to Date.new(2025, 12, 20)
      end

      after do
        travel_back
      end

      let!(:current_year_show) { FactoryBot.create(:show, user: user, dates: "December 25 2025") }
      let!(:next_year_show) { FactoryBot.create(:show, user: user, dates: "January 15") } # Will become 2026
      let!(:next_year_show2) { FactoryBot.create(:show, user: user, dates: "January 20") } # Will become 2026

      it "sorts year-less dates correctly across year boundaries" do
        # December 25 2025 should come before January 15 2026
        expect(described_class.valid_shows).to eq([current_year_show, next_year_show, next_year_show2])
      end

      it "handles chronological ordering across years" do
        shows = described_class.valid_shows
        expect(shows.first.start_date).to be < shows.second.start_date
        expect(shows.second.start_date).to be < shows.third.start_date
      end
    end

    context "with complex date scenarios" do
      before do
        travel_to Date.new(2025, 12, 20)
      end

      after do
        travel_back
      end

      let!(:late_2025_show) { FactoryBot.create(:show, user: user, dates: "December 30 2025") }
      let!(:early_2026_show) { FactoryBot.create(:show, user: user, dates: "January 5") } # Will become 2026
      let!(:mid_2026_show) { FactoryBot.create(:show, user: user, dates: "June 15") } # Will become 2026

      it "maintains chronological order across year boundaries" do
        expect(described_class.valid_shows).to eq([late_2025_show, early_2026_show, mid_2026_show])
      end

      it "ensures all dates are properly parsed with correct years" do
        shows = described_class.valid_shows
        expect(shows.first.start_date.year).to eq(2025)
        expect(shows.second.start_date.year).to eq(2026)
        expect(shows.third.start_date.year).to eq(2026)
      end
    end
  end

  describe "#future_shows and #past_shows" do
    before do
      travel_to Date.new(2025, 12, 20)
    end

    after do
      travel_back
    end

    let!(:future_show) { FactoryBot.create(:show, user: user, dates: "January 15") } # Will become 2026
    let!(:past_show) { FactoryBot.create(:show, user: user, dates: "January 15 2024") }

    it "correctly identifies future shows" do
      expect(described_class.future_shows).to include(future_show)
      expect(described_class.future_shows).not_to include(past_show)
    end

    it "correctly identifies past shows" do
      expect(described_class.past_shows).to include(past_show)
      expect(described_class.past_shows).not_to include(future_show)
    end
  end

  describe "edge cases" do
    it "handles blank dates gracefully" do
      # Create a show with valid dates first, then test the method behavior
      show = FactoryBot.create(:show, user: user, dates: "December 25 2025")
      # Test that the method handles blank strings gracefully
      expect(Show.new(dates: "   ").start_date).to be_nil
    end

    it "handles malformed date strings" do
      # Create a show with valid dates first, then test the method behavior
      show = FactoryBot.create(:show, user: user, dates: "December 25 2025")
      # Test that the method handles malformed dates gracefully
      expect(Show.new(dates: "invalid date").start_date).to be_nil
    end
  end
end

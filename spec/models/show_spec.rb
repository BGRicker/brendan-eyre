require 'rails_helper'

RSpec.describe Show, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe "#formatted_date" do
    let!(:show) { FactoryBot.create(:show, user: user, dates: "October 31") }

    it "converts the date string to a Date object" do
      expect(show.formatted_date.class).to eq(Date)
    end

    it "defaults to current year when no year is specified" do
      current_year = Date.current.year
      expect(show.formatted_date.year).to eq(current_year)
    end

    it "uses specified year when provided" do
      show_with_year = FactoryBot.create(:show, user: user, dates: "October 31 2025")
      expect(show_with_year.formatted_date.year).to eq(2025)
    end
  end

  describe "#valid_shows" do
    context "with single dates" do
      let!(:show) { FactoryBot.create(:show, user: user, dates: "October 25 - 31") }
      let!(:second_show) { FactoryBot.create(:show, user: user, dates: "November 12 - 15") }
      let!(:third_show) { FactoryBot.create(:show, user: user, dates: "November 25 - 30") }
      let!(:past_show) { FactoryBot.create(:show, user: user, dates: "January 1 2009") }

      it "shows only future dates" do
        expect(described_class.valid_shows).to eq([show, second_show, third_show])
        expect(described_class.valid_shows).not_to include(past_show)
      end
    end

    context "with range dates" do
      let!(:first_range_show) { FactoryBot.create(:show, user: user, dates: "October 25 - 31") }
      let!(:second_range_show) { FactoryBot.create(:show, user: user, dates: "September 5 - 8") }
      let!(:past_range_show) { FactoryBot.create(:show, user: user, dates: "January 25 - 29 2015") }

      it "shows only future dates" do
        expect(described_class.valid_shows).to eq([second_range_show, first_range_show])
        expect(described_class.valid_shows).not_to include(past_range_show)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Show, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe "#start_date" do
    let!(:show) { FactoryBot.create(:show, user: user, dates: "October 31 2025") }

    it "converts the date string to a Date object" do
      expect(show.start_date.class).to eq(Date)
    end
  end

  describe "#valid_shows" do
    context "with single dates" do
      let!(:show) { FactoryBot.create(:show, user: user, dates: "October 25 - 31 2025") }
      let!(:second_show) { FactoryBot.create(:show, user: user, dates: "November 12 - 15 2025") }
      let!(:third_show) { FactoryBot.create(:show, user: user, dates: "November 25 - 30 2025") }
      let!(:past_show) { FactoryBot.create(:show, user: user, dates: "January 1 2009") }

      it "shows only future dates ordered by end date" do
        expect(described_class.valid_shows).to eq([show, second_show, third_show])
        expect(described_class.valid_shows).not_to include(past_show)
      end
    end

    context "with range dates" do
      let!(:first_range_show) { FactoryBot.create(:show, user: user, dates: "October 25 - 31 2025") }
      let!(:second_range_show) { FactoryBot.create(:show, user: user, dates: "September 5 - 8 2025") }
      let!(:past_range_show) { FactoryBot.create(:show, user: user, dates: "January 25 - 29 2015") }

      it "shows only future dates ordered by end date" do
        expect(described_class.valid_shows).to eq([second_range_show, first_range_show]) # Sept 8 comes before Oct 31
        expect(described_class.valid_shows).not_to include(past_range_show)
      end
    end
  end
end

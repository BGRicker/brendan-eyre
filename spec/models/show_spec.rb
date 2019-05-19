require 'rails_helper'

RSpec.describe Show, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let!(:show) { FactoryBot.create(:show, user: user) }

  describe "#formatted_date" do
    it "converts the date string to a Date object" do
      expect(show.formatted_date.class).to eq(Date)
    end
  end

  describe "#valid_shows" do
    let!(:show) { FactoryBot.create(:show, user: user, dates: Date.current.to_s) }
    let!(:second_show) { FactoryBot.create(:show, user: user) }
    let!(:third_show) { FactoryBot.create(:show, user: user) }
    let!(:past_show) { FactoryBot.create(:show, user: user, dates: "January 1 2009") }

    it "shows only future dates" do
      expect(described_class.valid_shows).to eq([show, second_show, third_show])
      expect(described_class.valid_shows).not_to include(past_show)
    end
  end
end

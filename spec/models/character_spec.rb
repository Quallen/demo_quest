require 'rails_helper'

RSpec.describe Character, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:character) { FactoryBot.build(:character, user: user) }

  it "has a valid factory" do
    expect { character.save! }.to_not raise_error
  end
end

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  it "has a valid factory" do
    expect { user.save! }.to_not raise_error
  end
end

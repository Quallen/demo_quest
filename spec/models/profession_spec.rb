require 'rails_helper'

RSpec.describe Profession, type: :model do
  let(:profession) { FactoryBot.build(:profession) }

  it 'has a valid factory' do
    expect {profession.save!}.to_not raise_error
  end

  describe '.import' do
    let(:fixture_path) { (Rails.root.join("spec", "fixtures", "professions.csv")) }

    it 'imports professions from csv' do
      expect{described_class.import(file_path: fixture_path)}.to change{Profession.count}.by(2)
    end
  end
end

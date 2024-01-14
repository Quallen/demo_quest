require "rails_helper"

feature "Characters", js: true do
  let!(:user) { FactoryBot.create(:user) }

  before(:each) do
    login_as(user)
  end

  context "given a logged in user" do

    context 'with no characters' do
      it 'at least tells them they are on the right page' do
        visit characters_path
        expect(page).to have_content 'Characters Index'
      end
    end

    context 'with an existing character' do
      let!(:character) { FactoryBot.create(:character, user: user)}
      it 'displays their character' do
        visit characters_path
        expect(page).to have_content character.name
      end
    end
  end

end

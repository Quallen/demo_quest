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

    describe 'creating a character' do
      context 'on the characters index' do
        it 'has a link to create a character' do
          visit characters_path
          expect(page).to have_link(href: new_character_path)
        end
      end

      describe 'validations' do
        before(:each) do
          visit new_character_path
          click_button "Create Character"
        end
        it 'requires a name' do
          expect(page).to have_content "Name can't be blank"
        end
        it 'requires a gender' do
          expect(page).to have_content "Gender identity can't be blank"
        end
        it 'requires a date of birth' do
          expect(page).to have_content "Date of birth can't be blank"
        end
      end

      it "allows creation of a character" do
        visit new_character_path
        fill_in 'character_name', with: 'First Middle Last'
        fill_in 'character_gender_identity', with: 'agender'
        fill_in 'character_date_of_birth', with: '01/01/1970'
        click_button "Create Character"
        expect(page).to have_content "Character was successfully created."
      end
    end
  end

end

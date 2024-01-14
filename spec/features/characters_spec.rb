require "rails_helper"

feature "Characters", js: true do
  let!(:user) { FactoryBot.create(:user) }

  before(:each) do
    login_as(user)
  end

  context "given a logged in user" do

    describe 'index' do
      context 'with no characters' do
        it 'at least tells them they are on the right page' do
          visit characters_path
          expect(page).to have_content 'Characters Index'
        end

        it 'has a link to create a character' do
          visit characters_path
          expect(page).to have_link(href: new_character_path)
        end
      end

      context 'with an existing character' do
        let!(:character) { FactoryBot.create(:character, user: user)}
        before(:each) do
          visit characters_path
        end
        it 'displays their character name' do
          expect(page).to have_content character.name
        end

        it 'has a link to character show' do
          expect(page).to have_link(href: character_path(character))
        end

        it 'has a link to character edit' do
          expect(page).to have_link(href: edit_character_path(character))
        end
      end
    end

    describe 'creating a character' do
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

    describe 'show' do
      context 'given an alive character' do
        let!(:character) { FactoryBot.create(:character, user: user, alive: true)}

        it 'displays their character details' do
          visit character_path(character)
          expect(page).to have_content character.name
          expect(page).to have_content character.present_status
          expect(page).to have_content character.gender_identity
          expect(page).to have_content character.date_of_birth
        end
      end

      context 'given an deceased character' do
        let!(:character) { FactoryBot.create(:character, :deceased, user: user)}

        it 'displays when the character died' do
          visit character_path(character)
          expect(page).to have_content character.deceased_at
        end
      end

      describe 'edit' do
        context 'given an alive character' do
          let!(:character) { FactoryBot.create(:character, user: user, alive: true)}
          let(:new_name) { 'A New Name' }
          let(:new_gender) { 'agender' }

          it 'displays the edit form' do
            visit edit_character_path(character)
            expect(page).to have_field('character_name', with: character.name)
            expect(page).to have_field('character_gender_identity', with: character.gender_identity)
            expect(page).to have_field('character_date_of_birth', with: I18n.l(character.date_of_birth, format: :date_picker_value))
            expect(page).to have_button('Update Character')
          end
        end
      end
      describe 'update' do
        context 'given an alive character' do
          let!(:character) { FactoryBot.create(:character, user: user, alive: true)}
          context 'given an alive character' do
            let!(:character) { FactoryBot.create(:character, user: user, alive: true)}
            let(:new_name) { 'A New Name' }
            let(:new_gender) { 'agender' }

            it 'allows the user to edit character details' do
              visit edit_character_path(character)
              fill_in 'character_name', with: new_name
              fill_in 'character_gender_identity', with: new_gender
              click_button "Update Character"
              expect(page).to have_content "Character was successfully updated."
              expect(character.reload.name).to eq new_name
              expect(character.gender_identity).to eq new_gender
            end
          end
        end
      end
    end

  end
end

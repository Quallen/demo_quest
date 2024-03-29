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

        it 'has a link to delete the character' do
          expect(page).to have_link('Delete', href: character_path(character)) { |link| link["data-turbo-method"] == "delete"}
        end
      end
    end

    describe 'creating a character' do
      let!(:profession) { FactoryBot.create(:profession) }
      let(:profession_name) { profession.name }

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
        select profession_name, from: 'character_profession_id'
        click_button "Create Character"
        expect(page).to have_content "Character was successfully created."
      end
    end

    describe 'deleting a character' do
      let!(:character) { FactoryBot.create(:character, user: user, alive: true)}

      it 'destroys the character' do
        visit characters_path
        expect(page).to have_content "Characters Index"
        sleep 1
        expect { click_link "Delete" }.to change { Character.count }.by(-1)
        expect(page).to have_content "Character was successfully destroyed."
      end
    end

    describe 'show' do
      context 'given an alive character' do
        let!(:profession) {FactoryBot.create(:profession)}
        let!(:character) { FactoryBot.create(:character, user: user, alive: true, profession: profession)}

        it 'displays their character details' do
          visit character_path(character)
          expect(page).to have_content character.name
          expect(page).to have_content character.present_status
          expect(page).to have_content character.gender_identity
          expect(page).to have_content I18n.l(character.date_of_birth, format: :as_date)
          expect(page).to have_content character.profession.name
        end
      end

      context 'given an deceased character' do
        let!(:character) { FactoryBot.create(:character, :deceased, user: user)}

        it 'displays when the character died' do
          visit character_path(character)
          expect(page).to have_content I18n.l(character.deceased_at, format: :as_date)
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

          context 'without a profession' do
            let!(:new_profession) { FactoryBot.create(:profession) }
            let(:new_profession_name) { new_profession.name }

            it 'allows a profession to be saved' do
              visit edit_character_path(character)
              select new_profession_name, from: 'character_profession_id'
              click_button "Update Character"
              expect(page).to have_content "Character was successfully updated."
              expect(character.reload.profession).to eq new_profession
            end
          end
        end
      end
    end

  end
end

class CharactersController < ApplicationController
  def index
    @characters = current_user.characters
  end

  def new
    @character = Character.new
  end

  def create
    @character = current_user.characters.build(character_params)

    if @character.save
      redirect_to characters_path, notice: "Character was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def character_params
    params.require(:character).permit(:user, :name, :gender_identity, :date_of_birth)
  end
end

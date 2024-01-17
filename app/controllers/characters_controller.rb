class CharactersController < ApplicationController
  before_action :character_load, only: [:show, :edit, :update]

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

  def show
  end

  def edit
  end

  def update
    if @character.update(character_params)
      redirect_to characters_path, notice: "Character was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @character = current_user.characters.find(params[:id])

    @character.destroy

    redirect_to characters_path, notice: "Character was successfully destroyed."
  end

  def character_load
    @character = current_user.characters.find(params[:id])
  end

  def character_params
    params.require(:character).permit(:user, :name, :gender_identity, :date_of_birth, :profession_id)
  end
end

class AddProfessionIdToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_reference :characters, :profession, foreign_key: true
  end
end

class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.references :user, foreign_key: true

      t.boolean :alive, null: false, default: true
      t.string :name
      t.string :gender_identity
      t.datetime :date_of_birth
      t.datetime :deceased_at

      t.timestamps
    end
  end
end

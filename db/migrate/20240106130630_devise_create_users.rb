# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :email
      t.string :uid
      t.string :name
      t.string :nickname

      t.timestamps null: false
    end

    add_index :users, :uid, unique: true
  end
end

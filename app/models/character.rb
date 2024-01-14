class Character < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :gender_identity, presence: true
  validates :date_of_birth, presence: true

  def deceased?
    !alive
  end

  def present_status
    alive? ? "Alive" : "Deceased"
  end
end

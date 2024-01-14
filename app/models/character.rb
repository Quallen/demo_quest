class Character < ApplicationRecord
  belongs_to :user
  def present_status
    alive? ? "Alive" : "Deceased"
  end
end

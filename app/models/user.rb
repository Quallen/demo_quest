class User < ApplicationRecord
  has_many :characters

  devise :omniauthable, omniauth_providers: %i[auth0]

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.nickname = auth.info.nickname
    end
  end
end

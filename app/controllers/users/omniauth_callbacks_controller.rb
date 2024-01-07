class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def auth0
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user, :event => :authentication
  end

end

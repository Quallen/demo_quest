class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource_or_scope)
    characters_path
  end

  def after_sign_out_path_for(resource_or_scope)
    login_path
  end
end

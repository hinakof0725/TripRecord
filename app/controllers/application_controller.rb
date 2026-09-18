class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    mypage_path
  end
end

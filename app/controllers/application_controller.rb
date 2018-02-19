class ApplicationController < ActionController::Base
  private

  def set_user_session(user)
    session[:user_id] = user.id
  end

  def unset_user_session
    session[:user_id] = nil
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def signed_in?
    current_user.present?
  end
  helper_method :signed_in?

  def authenticate!
    redirect_to new_user_path and return unless signed_in?
  end
end

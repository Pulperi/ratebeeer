class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  def current_user
    return nil if session[:user_id].nil?
    begin
      return User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      return nil
    end
   end
  def clear_current_user
    session.clear
  end
  def ensure_that_signed_in
    redirect_to signin_path, notice:'you should be signed in' if not current_user
  end
end

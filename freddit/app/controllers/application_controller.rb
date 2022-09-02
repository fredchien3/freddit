class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def require_logged_in
    unless logged_in?
      flash[:errors] = ["You must be logged in to perform this action!"]
      redirect_to :root
    end
  end

  def login!(user)
    session[:session_token] = user.reset_session_token!
    @current_user = user
  end

  def logout!
    if current_user
      @current_user.reset_session_token!
      @current_user = nil
    end
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end
end

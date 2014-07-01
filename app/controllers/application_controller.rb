class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :login?, :current_user

  private

  class AccessDenied < Exception; end

  # rescue_from ActiveRecord::RecordNotFound,
  #               ActionController::RoutingError,
  #               ActionController::UnknownController,
  #               ActionController::UnknownFormat, 
  #               ActionController::UnknownHttpMethod do |exception|
  #   p 123123123

  #   redirect_to random_jokes_path
  # end

  def login_required
    unless login?
      flash[:warning] = t('sessions.flashes.login_required')
      redirect_to login_path(return_to: (request.fullpath if request.get?))
    end
  end

  def email_confirmed_required
    if !current_user.confirmed?
      redirect_to new_users_confirmation_path(return_to: (request.fullpath if request.get?))
    end
  end

  def no_locked_required
    if login? and current_user.locked?
      raise AccessDenied
    end
  end

  def no_login_required
    if login?
      redirect_to root_url
    end
  end

  def current_user
    @current_user ||= login_from_session || login_from_cookies unless defined?(@current_user)
    @current_user
  end

  def login?
    !!current_user
  end

  def login_as(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
    forget_me
  end

  def login_from_session
    if session[:user_id].present?
      begin
        User.find session[:user_id]
      rescue
        session[:user_id] = nil
      end
    end
  end

  def login_from_cookies
    if cookies[:remember_token].present?
      if user = User.find_by_remember_token(cookies[:remember_token])
        session[:user_id] = user.id
        user
      else
        forget_me
        nil
      end
    end
  end

  def login_from_access_token
    @current_user ||= User.find_by_access_token(params[:access_token]) if params[:access_token]
  end

  def store_location(path)
    session[:return_to] = path
  end

  def redirect_back_or_default(default)
    redirect_to(session.delete(:return_to) || default)
  end

  def forget_me
    cookies.delete(:remember_token)
  end

  def remember_me
    cookies[:remember_token] = {
      value: current_user.remember_token,
      expires: 2.weeks.from_now,
      httponly: true
    }
  end

  def set_seo_meta(title = nil, meta_keywords = nil, meta_description = nil)
    @page_title = "#{title}" if "#{title}".length > 0
    @meta_keywords = meta_keywords || Settings.app_keywords
    @meta_description = meta_description || Settings.app_description
  end  
end

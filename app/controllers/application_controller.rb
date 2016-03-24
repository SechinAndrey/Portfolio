class ApplicationController < ActionController::Base
  # respond_to :html, :json, :js
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  protect_from_forgery with: :exception
  before_action :set_locale


  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def ensure_signup_complete
    # Убеждаемся, что цикл не бесконечный
    return if action_name == 'finish_signup'

    # Редирект на адрес 'finish_signup' если пользователь
    # не подтвердил свою почту
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
end

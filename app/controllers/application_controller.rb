class ApplicationController < ActionController::Base

  helper_method :current_user
  # helper_method :set_current_user_board
  helper_method :authenticate_owner_of

  before_action :login_required


  private
  
  def authenticate_admin_user!
    redirect_to root_path, notice: '【！】不正なアクセスです' unless current_user.admin
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def login_required
    redirect_to login_path, notice: '【！】ログインしてください' unless current_user
  end

  def authenticate_owner_of(instance)
    if instance.try(:user_id) != current_user.id and !current_user.admin
      redirect_to root_path, notice: '【！】不正なアクセスです'
    end
  end

  def admin_required
    unless current_user.admin
      redirect_to root_path, notice: '【！】不正なアクセスです'
    end
  end


  # def authenticate_owner_of(instance)
  #   unless %w!Article Board Message!.include?(instance&.class.name) and instance.user_id == current_user.id
  #     redirect_to root_path, notice: '不正なアクセスです。'
  #   end
  # end
end

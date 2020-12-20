class AdminController < ApplicationController
  def top
  end

  private

  def require_admin
    redirect_to root_path, notice: '【！】不正なアクセスです' unless current_user.admin
  end
end

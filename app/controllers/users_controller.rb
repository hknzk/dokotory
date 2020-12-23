class UsersController < ApplicationController

  skip_before_action :login_required, only: [:new, :create]
  before_action :authenticate_user, only: [:edit, :update, :destroy, :edit_profile]
  before_action :set_user, only: [:show, :edit, :update, :destrtoy, :posted_articles, :edit_profile]

  def index
    #admin
    @users = User.all
  end

  def show
    @articles = @user.articles.where(is_published: true).order(created_at: :desc).limit(3)
  end

  def new
    #public
    @user = User.new(flash[:tmp_user])
  end

  def create
    #public
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = '会員登録を完了しました、ログインしてください。'
      redirect_to login_path
    else
      flash[:tmp_user] = @user
      flash[:error_msgs] = @user.errors.full_messages
      redirect_to new_user_path
    end
  end

  def edit
    #private admin
  end


  def update

  result = {boolean: nil, error_messages: nil}

  case secure_params[:target]
  when 'email'
    if @user.authenticate(secure_params[:current_password])
      result = User.validate_columns(email: user_params[:email])
      if result[:boolean]
        @user.email = user_params[:email]
        @user.save(validate: false)
        path = mypage_path
        flash[:notice] = 'メールアドレスを更新しました'
      else
        path = edit_user_path(@user)
        flash[:error_msgs] = result[:error_messages]
      end
    else
      path = edit_user_path(@user)
      flash[:notice] = '【！】パスワードが間違っています'
    end
  when 'password'
    if @user.authenticate(secure_params[:current_password])
      if @user.update(password: user_params[:password], password_confirmation: user_params[:password_confirmation])
        path = mypage_path
        flash[:notice] = 'パスワードを更新しました'
      else
        path = edit_user_path(@user)
        flash[:error_msgs] = @user.errors.full_messages
      end
    else
      path = edit_user_path(@user)
      flash[:notice] = '【！】パスワードが間違っています'
    end
  when 'profile'
    result = User.validate_columns(name: user_params[:name], avatar: user_params[:avatar])
    if result[:boolean]
      @user.name = user_params[:name]
      @user.avatar = user_params[:avatar] if user_params[:avatar].present?
      @user.save(validate: false)
      path = mypage_path
      flash[:notice] = 'プロフィールの編集をしました'
    else
      path = edit_profile_user_path(@user)
      flash[:error_msgs] = result[:error_messages]
    end
  end

  redirect_to path

    # boolean = nil
    # case secure_params[:target]
    #   when 'email'
    #     if @user.authenticate(secure_params[:current_password])
    #       boolean = @user.update(
    #          email: user_params[:email]
    #        )
    #       flash[:notice] = 'ログイン設定を更新しました'
    #     else
    #       boolean = false
    #       flash[:notice] = '【！】パスワードが間違っています'
    #     end
    #   when 'password'
    #     if @user.authenticate(secure_params[:current_password])
    #       boolean = @user.update(
    #          password: user_params[:password],
    #          password_confirmation: user_params[:password_confirmation]
    #        )
    #       flash[:notice] = 'ログイン設定を更新しました'
    #     else
    #       boolean = false
    #       flash[:notice] = '【！】パスワードが間違っています'
    #     end
    #   when 'profile'
    #     if user_params[:avatar].present?
    #       boolean = @user.update(
    #         name: user_params[:name],
    #         avatar: user_params[:avatar]
    #       )
    #     else
    #       boolean = @user.update_attributes(
    #         name: user_params[:name]
    #       )
    #     end
    #     flash[:notice] = 'プロフィールを更新しました'
    #   else
    #     boolean = false
    #     flash[:notice] = '【！】不正な入力です'
    # end
    #
    # if boolean
    #   redirect_to mypage_path
    # else
    #   flash[:error_msgs] = @user.errors.full_messages
    #   redirect_to edit_user_path(@user)
    # end
  end

  def edit_profile

  end

  def destroy #退会処理
    if @user.destroy
      # ログアウト処理
      redirect_to root_path
    else
      redirect_to root_path, notice: '【！】削除失敗' #my_page
    end
  end

  def posted_articles
    @articles = @user.articles.order(created_at: :desc)
  end

  private

  def user_params
    params[:user][:admin] = false
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation, :avatar)
  end

  def secure_params
    params[:user].require(:secure).permit(:target, :current_password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authenticate_user
    if !current_user.admin and current_user.id != params[:id].to_i
      redirect_to root_path, notice: '【！】不正なアクセスです'
    end

    # unless current_user.admin || current_user.id == params[:id]
    #   redirect_to root_path, notice: '【！】不正なアクセスです。'
    # end
  end
end

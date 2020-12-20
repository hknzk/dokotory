class MessagesController < ApplicationController

  before_action :set_user, except: [:destroy]
  before_action :set_message, only: [:show, :destroy]

  def new
    if params[:user_id] == current_user.id
      redirect_to root_path, notice: '【！】不正なアクセスです'
    end
    @user = User.find(params[:user_id])
    @message = current_user.send_messages.new(flash[:tmp_dm])
  end

  def show
    if current_user.id != @message.sender_id and current_user.id != @message.receiver_id
      redirect_to root_path, notice: '【！】不正なアクセスです'
    end
    @sender = @message.sender
  end

  def create
    @message = current_user.send_messages.new(message_params)
    if params[:user_id] == current_user.id
      redirect_to root_path, notice: '【！】不正なアクセスです'
    elsif @message.save
      @user.create_notification_message!(current_user, @message.id)
      redirect_to @user, notice: "#{@user.name}さんにメッセージを送りました"
    else
      flash[:tmp_dm] = @message
      flash[:error_msgs] =  @message.errors.full_messages
      redirect_to new_user_message_path(@user), notice: "【！】メッセージ送信に失敗しました"
    end
  end

  def destroy
    if current_user.id != @message.receiver_id
      redirect_to root_path, notice: "【！】不正なアクセスです"
    elsif @message.destroy
      redirect_to mypage_messages_path, notice: "メッセージを削除しました"
    else
      redirect_to mypage_messages_path, notice: "【！】メッセージ削除に失敗しました"
    end
  end

  private

  def message_params
    params.require(:message).permit(:name, :body).merge(receiver_id: params[:user_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_message
    @message = Message.find(params[:id])
  end
end

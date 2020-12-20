class CommentsController < ApplicationController

  before_action :set_article

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      @article.create_notification_comment!(current_user, @comment.id)
      redirect_to article_path(params[:article_id], anchor: "anchor_num_#{@comment.id}")
    else
      flash[:tmp_body] = @comment.body
      flash[:error_msgs] = @comment.errors.full_messages
      redirect_to article_path(params[:article_id], anchor: "anchor_failure")
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authenticate_owner_of(@comment)
    @comment.destroy!

    if @comment.destroy
      flash[:notice] = 'コメントを削除しました。'
    else
      flash[:notice] = '【！】コメントを削除できませんでした。'
    end
    redirect_to article_path(params[:article_id], anchor: 'comments_wrapper')
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :image).merge({
      user_id: current_user.id,
      article_id: params[:article_id],
      })
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  # def collate_board_owner
  #   @board = Board.find(params[:board_id])
  #   authenticate_owner_of(@board)
  # end
end

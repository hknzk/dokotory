class FavoritesController < ApplicationController

  before_action :set_article

  def create
    @favorite = Favorite.new(user_id: current_user.id, article_id: params[:article_id])
    if @favorite.save
      @article.create_notification_favorite!(current_user)
      render 'create.js.erb'
    end
    # unless Favoriote.create(user_id: current_user.id, article_id: params[:article_id])
    #   redirect_to article_path(params[:article_id]), notice: '【！】お気に入り登録できませんでした'
    # end
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, article_id: params[:article_id])
    if @favorite.destroy
      @favorite = nil
      render 'destroy.js.erb'
    end
    # fav = Favoriote.find_by(user_id: current_user.id, article_id: params[:article_id])
    # unless fav.destroy
    #   redirect_to article_path(params[:article_id]), notice: '【！】お気に入り解除できませんでした'
    # end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end
end

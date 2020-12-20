class MypageController < ApplicationController
  def top
    @posted_articles = current_user.articles.where(is_published: true).order(created_at: :desc).limit(3)
    @draft_articles = current_user.articles.where(is_published: false).order(created_at: :desc).limit(3)
    @comments = current_user.comments.order(created_at: :desc).limit(3)
    @favorites = current_user.favorites.includes(article: :user).order(created_at: :desc).limit(3)
    @articles_in_progress= art_in_progress.slice(0..2)
  end

  def posted_articles
    @posted_articles = current_user.articles.where(is_published: true).order(created_at: :desc).page(params[:page]).per(10)
  end

  def draft_articles
    @draft_articles = current_user.articles.where(is_published: false).order(created_at: :desc).page(params[:page]).per(10)
  end

  def articles_in_progress
    @articles_in_progress = art_in_progress.page(params[:page]).per(10)
  end

  def received_messages
    @received_messages = current_user.received_messages.includes(:receiver).order(created_at: :desc).page(params[:page]).per(10)
  end

  def send_messages
    @send_messages = current_user.send_messages.includes(:sender).order(created_at: :desc).page(params[:page]).per(10)
  end

  def favorites
    @favorites = current_user.favorites.includes(article: :user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def notifications
    @notifications = current_user.passive_notifications.order(created_at: :desc)
    @notifications.where(checked: false).each do |n|
      n.update_attributes(checked: true)
    end
    @notifications = @notifications.where.not(visitor_id: current_user.id).page(params[:page]).per(10)
  end

  private

  def art_in_progress
    article_ids = current_user.comments.select(:article_id).distinct
    Article.where(id: article_ids.map(&:article_id)).includes(:user).order(created_at: :desc)
    # combined = current_user.comments.includes(article: :user).order(created_at: :desc)
    # extracted = []
    # combined.each do |c|
    #   next unless c.article.is_published
    #   extracted << {article: c.article, user: c.article.user}
    # end
    # extracted.uniq
  end
end

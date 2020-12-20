class HomeController < ApplicationController

  skip_before_action :login_required

  def top
    @articles = Article.where(is_published: true).order(created_at: :desc).limit(6)
    graph_values = []
    10.times {|i| graph_values << Article.where(is_published: true, created_at: i.day.ago.all_day).count}
    gon.graph_values = graph_values.reverse
  end

  def info
  end

  def j_sample
    @article = Article.first
    render 'j_sample.js.erb'
  end

  private
  def target_params
    params.permit(:target_article_id)
  end
end

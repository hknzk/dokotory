class ArticlesController < ApplicationController
  PREFECTURES = {
    hokkaido:'hokkaido',aomori:'aomori',iwate:'iwate',miyagi:'miyagi',
    akita:'akita',yamagata:'yamagata',fukushima:'fukushima',
    ibaragi:'ibaragi',tochigi:'tochigi',gunma:'gunma',saitama:'saitama',
    chiba:'chiba',tokyo:'tokyo',kanagawa:'kanagawa',niigata:'niigata',
    toyama:'toyama',ishikawa:'ishikawa',fukui:'fukui',yamanashi:'yamanashi',
    nagano:'nagano',gifu:'gifu',shizuoka:'shizuoka',aichi:'aichi',
    mie:'mie',shiga:'shiga',kyoto:'kyoto',osaka:'osaka',
    hyogo:'hyogo',nara:'nara',wakayama:'wakayama',tottori:'tottori',
    shimane:'shimane',okayama:'okayama',hiroshima:'hiroshima',yamaguchi:'yamaguchi',
    tokushima:'tokushima',kagawa:'kagawa',ehime:'ehime',kochi:'kochi',
    fukuoka:'fukuoka',saga:'saga',nagasaki:'nagasaki',kumamoto:'kumamoto',
    oita:'oita',miyazaki:'miyazaki',kagoshima:'kagoshima',okinawa:'okinawa'
  }

  before_action :set_article, only: [:show, :visitor, :edit, :update, :destroy]
  before_action -> { authenticate_owner_of(@article) }, only: [:edit, :update, :destroy]
  skip_before_action :login_required, only: [:index, :show, :visitor, :map, :load_detail]

  def index
    if search_params[:sort_by_newest].present?
      @is_box_checked = search_params[:sort_by_newest] == '1' ? true :  false
    else
      @is_box_checked = true
    end

    @new_comments = Comment.all.order(created_at: :desc).limit(10).includes(:article)
    @search_params = search_params
    @articles = search_params.present? ? Article.published.search(@search_params) : Article.published.order(created_at: :desc)
    @articles = @articles.page(params[:page]).per(10)
  end

  def new
    @article = current_user.articles.new(flash[:tmp_article])
    @article.build_map
  end

  def create
    @article = current_user.articles.new(article_params)
    # @article.build_map(map_params)
    if @article.save
      if @article.is_published
        redirect_to article_path(@article), notice: "記事を保存し公開しました"
      else
        redirect_to root_path(@article), notice: "記事を下書きとして保存しました"
      end
    else
      flash[:tmp_article] = @article
      flash[:error_msgs] = @article.errors.full_messages
      redirect_to new_article_path
    end
  end

  def visitor
    @comments = @article.comments.includes(:user)
    @contributor = @article.user
  end

  def show
    if current_user.blank?
      redirect_to visitor_article_path(@article)
    elsif !@article.is_published
      redirect_to root_path, notice: '【！】不正なアクセスです'
    else
      @favorite = current_user.favorites.find_by(article_id: params[:id])
      @new_comment = Comment.new(body: flash[:tmp_body])
      @comments = @article.comments.includes(:user)
      @contributor = @article.user
    end
  end

  def edit
  end

  def update
    @article.update(article_params)
    if @article.is_published
      redirect_to article_path(@article), notice: "記事を保存し公開しました"
    else
      redirect_to root_path(@article), notice: "記事を下書きとして保存しました"
    end
  rescue
    flash[:tmp_article] = @article
    flash[:error_msgs] = @article.errors.full_messages
    redirect_to edit_article_path(@article), notice: '【！】記事の更新に失敗しました'
  end

  def destroy
    if @article.destroy
      redirect_to root_path
    else
      redirect_to root_path, notice: '【！】削除に失敗しました'
    end
  end

  def map
    gon.clear
    # @selected_prefecture = prefectures[map_location_params[:map_location]&.to_sym]
    if map_location_params[:map_location].present?
      gon.centerPrefecture = PREFECTURES[map_location_params[:map_location].to_sym]
      gon.maps = Map.active_maps.where(prefecture:map_location_params[:map_location])
    else
      gon.centerPrefecture = nil
      gon.maps = nil
    end
  end

  def load_detail
    @article = Article.find_by(id: article_id_params[:article_id])
    render 'load_detail.js.erb'
  end

  private


  def map_params
    params.require(:map).permit(:id, :is_enabled, :lat, :lng)
  end

  def article_params
    atcl_params = params.require(:article).permit(
      :name,
      :body,
      :condition,
      :species,
      :prefecture,
      :municipality,
      :is_published,
      :is_resolved,
      images: []
      # map_attributes: [:id, :is_enabled, :lat, :lng]
    )
    mp_params = map_params.merge({
      is_article_published: atcl_params[:is_published],
      prefecture: atcl_params[:prefecture]
      })

    atcl_params.merge({map_attributes: mp_params})
  end

  def map_location_params
    params.permit(:map_location)
  end

  def article_id_params
    params.permit(:article_id)
  end

  def search_params
    s_params = params.fetch(:search, {}).permit(
      :text,
      :prefecture,
      :species,
      :posted_date_from,
      :posted_date_to,
      :sort_by_newest
    )
    # s_params.merge({sort_by_newest: s_params[:sort_by_newest] == '1' ? true : false })
  end

  def set_article
    @article = Article.find(params[:id])
    @map = @article.map
  end

  # def block_visitor(article)
  #   if current_user.blank?
  #     redirect_to login_path
  #   elsif article.user_id != current_user.id
  #     set_current_user_board(article.id)
  #     redirect_to article_board_path(article, @board)
  #   end
  # end

  # def create_or_set_board(article)
  #   @board = article.boards.find_by(user_id: current_user.id)
  #   if @board.nil?
  #     @board = article.boards.new(user_id: current_user.id)
  #     @board.save
  #   end
  # end

end

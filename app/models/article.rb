class Article < ApplicationRecord


  belongs_to :user
  has_one :map, dependent: :destroy
  has_many_attached :images, dependent: :purge_later
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

  accepts_nested_attributes_for :map
  validates_associated :map

  enum species: {
    budgerigar: 'budgerigar',
    lovebird: 'lovebird',
    cockatiel: 'cockatiel',
    canary: 'canary',
    java_sparrow: 'java_sparrow',
    barred_parakeet: 'barred_parakeet',
    other: 'other'
  }

  enum prefecture: {
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

  scope :search, -> (search_params) do
    if search_params.blank?
      order(created_at: :asc)
    elsif search_params.except(:sort_by_newest).blank?
      order(created_at: search_params[:sort_by_newest] == '1' ? :desc : :asc )
    else
      text_like(search_params[:text])
        .prefecture_is(search_params[:prefecture])
        .species_is(search_params[:species])
        .posted_date_from(search_params[:posted_date_from])
        .posted_date_to(search_params[:posted_date_to])
        .order(created_at: search_params[:sort_by_newest] == '1' ? :desc : :asc )
    end
  end

  scope :published, -> { where(is_published: true)}
  scope :text_like, -> (text) { where("CONCAT(name, body, condition, municipality) LIKE ?", "%#{text}%") if text.present? }
  scope :prefecture_is, -> (prefecture) { where(prefecture: prefecture) if prefecture.present? }
  scope :species_is, -> (species) { where(species: species) if species.present? }
  scope :posted_date_from, -> (posted_date_from) { where("? <= created_at", posted_date_from.in_time_zone('UTC') ) if posted_date_from.present? }
  scope :posted_date_to, -> (posted_date_to) { where("created_at <= ?", posted_date_to.in_time_zone('UTC') ) if posted_date_to.present? }


  # articleのバリデーション
  before_validation :set_empty_municipality

  validates :name, presence: true, length: {maximum: 50}
  validates :body, presence: true, length: {maximum: 1000 }
  validates :condition, presence: true, length: {maximum: 1000}
  validates :species, presence: true
  validates :prefecture, presence: true
  validates :municipality, length: {maximum: 50}
  # mapのバリデーション
  validate :validate_blank_value_when_map_disabled

  def t_prefecture #{prefectureの日本語化メソッド}
    self.prefecture ? I18n.t("enums.article.prefecture.#{self.prefecture}") : nil
  end

  def t_species #{prefectureの日本語化メソッド}
    self.species ? I18n.t("enums.article.species.#{self.species}") : nil
  end

  def create_notification_favorite!(current_user)
    temp = Notification.where(
      visitor_id: current_user.id,
      visited_id: self.user_id,
      article_id: self.id,
      action: 'favorite'
    )
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: self.user_id,
        article_id: self.id,
        action: 'favorite'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      puts self.user_id
      puts self.user_id
      puts self.user_id
      puts self.user_id
      puts self.user_id
      puts notification.valid?
      puts notification.valid?
      notification.save!
      # notification.save if notification.valid?
      # notification.save if notification.valid?
    end

  end

  def create_notification_comment!(current_user, comment_id)
    commenter_ids = self.comments.select(:user_id).where.not(user_id: current_user.id).distinct

    commenter_ids.each do |commenter_id|
      save_notification_comment!(current_user, comment_id, commenter_id[:user_id])
    end

    save_notification_comment!(current_user, comment_id, self.user_id) if commenter_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      visited_id: visited_id,
      article_id: self.id,
      comment_id: comment_id,
      action: 'comment'
    )

    if notification.visitor_id ==  notification.visited_id
      notification.checked = true
    end

    notification.save if notification.valid?
  end



  private

  def set_empty_municipality
    self.municipality = '未設定' if municipality.blank?
  end

  def validate_blank_value_when_map_disabled
    if self.map.is_enabled
      errors.add('マップ', 'で場所を指定してください') if self.map.lat.blank? || self.map.lng.blank?
    end
  end

  # def foobar
  #   puts 'aaaaaa'
  #   puts 'aaaaaa'
  #   puts self.map.inspect
  #   puts 'aaaaaa'
  #   puts 'aaaaaa'
  # end

  # hokkaido:'北海道',aomori:'青森',iwate:'岩手',miyagi:'宮城',
  # akita:'秋田',yamagata:'山形',fukushima:'福島',
  # ibaragi:'茨城',tochigi:'栃木',gunma:'群馬',saitama:'埼玉',
  # chiba:'千葉',tokyo:'東京',kanagawa:'神奈川',niigata:'新潟',
  # toyama:'富山',ishikawa:'石川',fukui:'福井',yamanashi:'山梨',
  # nagano:'長野',gifu:'岐阜',shizuoka:'静岡',aichi:'愛知',
  # mie:'三重',shiga:'滋賀',kyoto:'京都',osaka:'大阪',
  # hyogo:'兵庫',nara:'奈良',wakayama:'和歌山',tottori:'鳥取',
  # shimane:'島根',okayama:'岡山',hiroshima:'広島',yamaguchi:'山口',
  # tokushima:'徳島',kagawa:'香川',ehime:'愛媛',kochi:'高知',
  # fukuoka:'福岡',saga:'佐賀',nagasaki:'長崎',kumamoto:'熊本',
  # oita:'大分',miyazaki:'宮崎',kagoshima:'鹿児島',okinawa:'沖縄'
end

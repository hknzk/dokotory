class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password

  has_one_attached :avatar, dependent: :purge_later

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :send_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'
  has_many :favorites, dependent: :destroy

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  # validates :password_confirmation, presence: true, length: { minimum: 6 }, on: :create
  # validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, length: { minimum: 6 }
  validates :password, presence: true, length: { minimum: 6 }



  # validates :password_digest, presence: true, length: { minimum: 6 }

  validate :password_not_equal_to_email

  def self.validate_columns(columns)
    user = User.new(columns)
    col_names = columns.keys.map(&:to_s)
    user.valid?
    user.errors.keys.each do |k|
      user.errors.delete(k) unless col_names.include?(k.to_s)
    end
    {boolean: user.errors.empty?, error_messages: user.errors.full_messages}
  end

  def create_notification_message!(current_user, message_id)
    notification = current_user.active_notifications.new(
      visited_id: self.id,
      message_id: message_id,
      action: 'message'
    )

    notification.save if notification.valid?
  end

  private

  def password_not_equal_to_email
    if password&.eql?(email)
      errors.add(:email, 'はパスワードと同じにすることはできません')
      errors.add(:password, 'はメールアドレスと同じにすることはできません')
    end
  end
end

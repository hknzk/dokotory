class Comment < ApplicationRecord

  belongs_to :article
  belongs_to :user

  has_one_attached :image, dependent: :purge_later

  validate :validate_empty_body
  validates :body, length: {maximum: 250}

  has_many :notifications, dependent: :destroy

  private

  def validate_empty_body
    errors.add(:body, 'を入力してください') unless /[^\s　]/ =~ self.body
  end
end

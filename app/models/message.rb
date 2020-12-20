class Message < ApplicationRecord

  validates :name, presence: true, length: {maximum: 25}
  validates :body, length: {maximum: 500}

  validate :validate_empty_body
  validate :is_sender_not_equal_to_receiver

  belongs_to :sender, class_name: 'User', optional: true, foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', optional: true, foreign_key: 'receiver_id'

  has_one :notification, dependent: :destroy

  private

  def validate_empty_body
    errors.add(:body, 'を入力してください') unless /[^\s　]/ =~ self.body
  end

  def is_sender_not_equal_to_receiver
    error.add(:sender, 'と受信者が同じユーザーです') if self.sender_id == self.receiver_id
  end
end

class User < ApplicationRecord
  has_secure_password
  mount_uploader :image, UserUploader

  has_many :following_friends, foreign_key: "follower_id", class_name: "Friend", dependent: :destroy
  has_many :followings, through: :following_friends

  has_many :follower_friends, foreign_key: "following_id", class_name: "Friend", dependent: :destroy
  has_many :followers, through: :follower_friends

  has_many :user_groups
  has_many :groups, through: :user_groups

  validates :password, length: {minimum: 4}, on: :create
  validates :password, length: {minimum: 4}, on: :update, allow_blank: true

  VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}[-(]?\d{4}|\d{2}[-(]?\d{3}|\d{3}[-(]?\d{2}|\d{4}[-(]?\d{1})[-)]?\d{4}\z|\A0[5789]0[-]?\d{4}[-]?\d{4}\z/
  validates :call, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }

  # def following?(other_user)
  #   following_friends.find_by(following_id: other_user.id)
  # end

  # def follow!(other_user)
  #   following_friends.create!(following_id: other_user.id)
  # end

  # def unfollow!(other_user)
  #   following_friendss.find_by(following_id: other_user.id).destroy
  # end
end

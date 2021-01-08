class Group < ApplicationRecord
  mount_uploader :image, UserUploader

  has_many :user_groups
  has_many :users, through: :user_groups
end

class User < ApplicationRecord
  before_validation {email.downcase!}
  before_destroy ConfirmDeletionOfAdminCallback

  validates :name, presence: true, length: {maximum: 30}
  validates :email, presence: true, length: {maximum: 255}, uniqueness: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  has_secure_password
  has_many :tasks, dependent: :destroy
  enum admin: {admin: true,  not_admin: false}
end

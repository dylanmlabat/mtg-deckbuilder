class User < ActiveRecord::Base
  has_many :decks
  validates :name, uniqueness: true
  validates :email, uniqueness: true
  has_secure_password
end

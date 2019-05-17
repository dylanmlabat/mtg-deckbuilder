class User < ActiveRecord::Base
  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

  has_many :decks
  validates :name, uniqueness: true
  validates :email, uniqueness: true
  has_secure_password
end

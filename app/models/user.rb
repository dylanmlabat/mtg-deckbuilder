class User < ActiveRecord::Base
  has_many :decks
  has_secure_password validations: false
end

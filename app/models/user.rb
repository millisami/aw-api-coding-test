class User < ApplicationRecord
  has_secure_password
  
  has_many :contents

  validates :email, presence: true, uniqueness: true, format: /\b[A-Z0-9._%-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,8}\b/i
  validates :password, presence: true, length: { minimum: 6 }
  validates :first_name, presence: true
  validates :last_name, presence: true
end

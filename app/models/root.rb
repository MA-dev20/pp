class Root < ApplicationRecord
  has_secure_password
    
  has_many :root_admins
  has_many :admins, through: :root_admins
end

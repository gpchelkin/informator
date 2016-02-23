class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :rememberable and :omniauthable, :registerable, :recoverable, :validatable
  devise :database_authenticatable, :timeoutable, :trackable
end

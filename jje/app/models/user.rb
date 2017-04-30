class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  self.primary_key = 'user_id'
  
  has_many :submissions, class_name: 'UserSubmission'

  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(:email => data["email"]).first

      unless user
          user = User.create(display_name: data["name"],
              email: data["email"],
              password: Devise.friendly_token[0,20]
          )
      end
      user
  end
end


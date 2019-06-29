class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :omniauthable,:omniauth_providers => [:instagram]

  def self.find_for_oauth(auth)
  	 user = User.where(uid: auth.uid, provider: auth.provider).first
  	 unless user
  		nickname = auth.info.name if auth.provider == 'instagram'

  		user = User.create(
  			uid:      auth.uid,
  			provider: auth.provider,
  			nickname: nickname,
  			email:    User.dummy_email(auth),
  			password: Devise.friendly_token[0, 20]
  			)
  	 end
  	 user
  end

  private
     def self.dummy_email(auth)
  	      "#{auth.uid}-#{auth.provider}@example.com"
     end
end
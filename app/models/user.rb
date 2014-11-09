# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable, 
         :confirmable, :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :authorizations, dependent: :destroy
  has_many :questions, foreign_key: 'author_id', dependent: :destroy

  def author_of?(object)
    self == object.author
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info.email
    user = User.where(email: email).first if email

    if user
      user.create_authorization(auth)
    else
      user = User.create_user_for_oauth(email, auth.uid, auth.provider)
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  private

  def self.create_user_for_oauth(email, uid, provider)
    password = Devise.friendly_token[0, 20]
    temp_email = "#{TEMP_EMAIL_PREFIX}-#{uid}-#{provider}.com"
    user = User.new(
      email: email ? email : temp_email,
      password: password,
      password_confirmation: password
    )
    user.skip_confirmation!
    user.save!
    user
  end
end

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
#  admin                  :boolean
#  username               :string(255)      default(""), not null
#

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  USERNAME_REGEX = /\A[\w\d_]+\z/

  devise :database_authenticatable, :registerable, 
         :confirmable, :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :authorizations, dependent: :destroy
  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..64 }, 
            format: { with: USERNAME_REGEX, message: "allows only latin letters, numbers, and underscore." }

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
      user = User.create_user_for_oauth(email, auth)
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

  def self.create_user_for_oauth(email, auth)
    password = Devise.friendly_token[0, 20]
    username = "#{auth.provider}_#{auth.uid}"
    temp_email = "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
    user = User.new(
      username: username,
      email: email ? email : temp_email,
      password: password,
      password_confirmation: password
    )
    user.skip_confirmation!
    user.save!
    user
  end
end

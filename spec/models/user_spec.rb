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

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:authorizations) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

      context 'user already exists' do
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'create authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com'}) }

        it 'creates new user' do
           expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.create_user_for_oauth' do
    let(:email) { 'new@user.com' }
    let(:provider) { 'facebook' }
    let(:uid) { '123456' }

    it 'creates new user' do
      expect { User.create_user_for_oauth(email, uid, provider) }.to change(User, :count).by(1)
    end

    it 'skips user confirmation' do
      user = User.create_user_for_oauth(email, uid, provider)
      expect(user.confirmed?).to eq true
    end

    it 'fills user email when email is provided' do
      user = User.create_user_for_oauth(email, uid, provider)
      expect(user.email).to eq email
    end

    it 'fills user email with temp value when email is not provided' do
      user = User.create_user_for_oauth(nil, uid, provider)
      temp_email = "change@me-#{uid}-#{provider}.com"
      expect(user.email).to eq temp_email
    end
  end

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:object_author) { create(:user) }
    let(:object) { create(:question, author: object_author) }

    it 'false when user is not an author of the object' do
      expect(user.author_of?(object)).to eq false
    end

    it 'true when user is an author of the object' do
      expect(object_author.author_of?(object)).to eq true
    end
  end

  describe '#email_verified?' do
    let(:user) { create(:user) }
    let(:user_with_temp_email) { create(:user, email: "change@me-123456-twitter.com" )}

    it 'false when user have temp email' do
      expect(user_with_temp_email.email_verified?).to eq false
    end

    it 'true when user have verified email' do
      expect(user.email_verified?).to eq true
    end
  end
end

require 'feature_helper'

feature 'Social auth', %q{
  In order to be able to ask questions
  As an user
  I want to be able to authenticate via social networks
} do

  background do
    mock_auth_hash
    visit new_user_session_path
  end

  context 'When social network provides email' do   
    context 'new user' do
      scenario 'sign in with facebook' do
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from facebook account.'
      end
    end

    context 'user with existing authorization' do
      given(:user) { create :user }

      scenario 'sign in with facebook' do
        create :authorization, provider: 'facebook', uid: '123456', user: user
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from facebook account.'
      end
    end

    context 'user with account in other social network' do
      given(:user) { create :user, email: 'user@test.com' }

      scenario 'Sign in with facebook' do
        create :authorization, provider: 'twitter', uid: '654321', user: user
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from facebook account.'
      end  
    end
  end

  context 'When social network does not provide email' do
    context 'new user' do
      scenario 'sign in with twitter' do
        click_on 'Sign in with Twitter'
        fill_in 'Email', with: 'user@test.com'
        click_button 'Continue'

        expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
      end
    end

    context 'user with existing authorization' do
      given!(:user) { create :user }

      scenario 'sign in with twitter' do
        create :authorization, provider: 'twitter', uid: '123456', user: user
        click_on 'Sign in with Twitter'

        expect(current_path).to eq root_path
        expect(page).to have_content 'Successfully authenticated from twitter account.'
      end
    end
  end
end
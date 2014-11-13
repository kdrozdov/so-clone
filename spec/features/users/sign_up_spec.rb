require 'feature_helper'

feature 'User sign up', %q{
  In order to be able to authenticate
  As an User
  I want to be able to sign up
} do

  given(:user) { create(:user) }

  scenario 'User sign up with email and password' do
    visit new_user_registration_path
    fill_in 'Username', with: 'newuser'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
  end

  scenario 'User can not sign up when email has already been taken' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Username', with: 'newuser'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'User can not sign up when username has already been taken' do
    visit new_user_registration_path
    fill_in 'Username', with: user.username
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_button 'Sign up'

    expect(page).to have_content 'Username has already been taken'
  end

  scenario 'User can not sign up without email or password' do
    visit new_user_registration_path
    click_button 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'User can not sign up without username' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_button 'Sign up'

    expect(page).to have_content "Username can't be blank"
  end

  scenario "User can not sign up when password and confirmation does't match" do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Username', with: 'newuser'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345677'
    click_button 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end

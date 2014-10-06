require "feature_helper"

feature "User sign in", %q{
	In order to be able to ask questions
	As an user
	I want to be able to sign in
} do
	given(:user) { create(:user) }

	scenario "Registered user try to sign in" do 
		sign_in(user)

		expect(page).to have_content "Signed in successfully."
		expect(current_path).to eq root_path
	end

	scenario "Non-registered user try to sign in" do
		visit new_user_session_path
		fill_in "Email", with: "aaa@test.com"
		fill_in "Password", with: "12345678"
		click_button "Sign in"

		expect(page).to have_content "Invalid email address or password."
		expect(current_path).to eq new_user_session_path
	end
end
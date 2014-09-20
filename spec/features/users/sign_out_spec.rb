require "rails_helper"

feature "User sign out", %q{
	As an authenticated user
	I want to be able to sign in
} do
	given(:user) { create(:user) }

	scenario "Authenticated user try to sign out" do 
		sign_in(user)
		click_on "Sign out"

		expect(page).to have_content "Signed out successfully."
		expect(current_path).to eq root_path
	end

	scenario "Non-authenticated user can not sign out" do
		visit root_path

		expect(page).not_to have_link "Sign out"
	end
end
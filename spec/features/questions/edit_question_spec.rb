require "rails_helper"

feature "Edit question", %q{
	In order to amend
  	As an author of the question
  	I want to be able to edit question
} do

	given(:user) { create(:user) }
	given(:author) { create(:user) }
	given(:question) { create(:question, author: author) }

	scenario "User edits own question" do
		sign_in(author)
		visit question_path(question)

		click_on "Edit question"
		fill_in "Title", with: "Edited title"
		fill_in "Body", with: "Edited body"
		click_on "Save"

		expect(current_path).to eq question_path(question)	
		expect(page).to have_content "Edited title"
		expect(page).to have_content "Edited body"
	end

	scenario "User can not edit not own question" do
		sign_in(user)
		visit question_path(question)

		expect(page).not_to have_link "Edit"
	end

	scenario "Non-authenticated user can not edit question" do
		visit question_path(question)

		expect(page).not_to have_link "Edit"
	end
end
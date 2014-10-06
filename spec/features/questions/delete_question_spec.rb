require 'feature_helper'

feature "Delete question", %q{ 
  As an author of the question
  I want to be able to delete question
} do

	given(:user) { create(:user) }
	given(:author) { create(:user) }
	given(:question) { create(:question, author: author) }

	scenario "User deletes own question" do
		sign_in(author)
		visit question_path(question)

		click_on "Delete question"

		expect(current_path).to eq root_path	
		expect(page).to have_content "Your question successfully deleted."
	end

	scenario "User can not delete not own question" do
		sign_in(user)
		visit question_path(question)

		expect(page).not_to have_link "Delete question"
	end

	scenario "Non-authenticated user can not delete question" do
		visit question_path(question)

		expect(page).not_to have_link "Delete question"
	end
end
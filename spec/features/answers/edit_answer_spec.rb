require 'feature_helper'

feature 'Editing answer', %q{
	In order to fix mistake
	As an author of the answer
	I want to be able to edit my answer
} do

	given(:user) { create(:user) }
	given!(:question) { create(:question) }
	given!(:answer) { create(:answer, question: question) }

	scenario 'User edit his own answer', js: true do
		sign_in answer.author
		visit question_path(question)

		within "#answer_#{ answer.id }" do
			click_on 'Edit'
			fill_in 'Answer', with: 'Edited answer'
			click_on 'Save'

			expect(current_path).to eq question_path(question)
			expect(page).not_to have_content answer.body
			# save_screenshot('../screens/1.png')
			expect(page).to have_content 'Edited answer'
			expect(page).not_to have_selector 'textarea'
		end
	end

	scenario "Authenticated user try to edit other user's answer" do
		sign_in user
		visit question_path(question)

		expect(page).not_to have_link 'Edit'
	end

	scenario 'Non-authenticated user try to edit answer' do
		visit question_path(question)

		expect(page).not_to have_link 'Edit'
	end
end
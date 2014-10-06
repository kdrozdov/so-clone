require 'feature_helper'

feature 'Editing answer', %q{
	In order to fix mistake
	As an author of answer
	I want to be able to edit my answer
} do

	given(:user) { create(:user) }
	given(:author) { create(:user) }
	given(:question) { create(:question) }
	given!(:answer) { create(:answer, question: question, author: author) }

	scenario 'User edit his own answer', js: true do
		sign_in author
		visit question_path(question)
		find('.edit_answer_link').click

		within "#answer_form_#{ answer.id }" do
			fill_in 'Answer', with: 'Edited answer'
			click_on 'Save'
		end

		within "#answer_#{ answer.id }" do
			expect(current_path).to eq question_path(question)
			expect(page).not_to have_content answer.body
			expect(page).to have_content 'Edited answer'
			expect(page).not_to have_selector 'textarea'
		end
	end

	scenario "Authenticated user try to edit other user's answer" do
		sign_in user
		visit question_path(question)

		within '.answers' do
			expect(page).to_not have_link 'Edit'
		end
	end

	scenario 'Non-authenticated user try to edit answer' do
		visit question_path(question)

		within '.answers' do
			expect(page).to_not have_link 'Edit'
		end
	end
end
require 'feature_helper'

feature 'Add comment to Answer', %q{
  In order to clarify Answer
  As an authenticated user
  I want to be able to comment answer
} do

  given(:answer) { create :answer }
  given(:user) { create(:user) }

  scenario 'Authenticated user creates comment with valid attributes', js: true do
    sign_in user
    visit question_path(answer.question)

    within '.answer-wrapper' do
      click_on 'Add a comment'
      fill_in 'Comment', with: 'Answer comment'
      click_on 'Save'
      wait_for_ajax

      expect(current_path).to eq question_path(answer.question)
      expect(page).to have_text('Answer comment')
      expect(page).not_to have_selector 'textarea'
    end
  end

  scenario 'Authenticated user creates comment with invalid attributes', js: true do
    sign_in user
    visit question_path(answer.question)

    within '.answer-wrapper' do
      click_on 'Add a comment'
      click_on 'Save'

      wait_for_ajax

      expect(current_path).to eq question_path(answer.question)
      expect(page).to have_text("body can't be blank")
    end
  end

  scenario "Non-authenticated user tries to create comment" do
    visit question_path(answer.question)

    within '.answer-wrapper' do
      expect(page).not_to have_link("Add a comment")
    end
  end
end
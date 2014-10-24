require 'feature_helper'

feature 'Add comment to Question', %q{
  In order to clarify Question
  As an authenticated user
  I want to be able to comment question
} do

  given(:question) { create :question }
  given(:user) { create(:user) }

  scenario 'Authenticated user creates comment with valid attributes', js: true do
    sign_in user
    visit question_path(question)

    within '.question' do
      click_on 'Add a comment'
      fill_in 'Comment', with: 'Question comment'
      click_on 'Save'
      wait_for_ajax

      expect(current_path).to eq question_path(question)
      expect(page).to have_text('Question comment')
      expect(page).not_to have_selector 'textarea'
    end
  end

  scenario 'Authenticated user creates comment with invalid attributes', js: true do
    sign_in user
    visit question_path(question)

    within '.question' do
      click_on 'Add a comment'
      click_on 'Save'

      wait_for_ajax

      expect(current_path).to eq question_path(question)
      expect(page).to have_text("body can't be blank")
    end
  end

  scenario "Non-authenticated user tries to create comment" do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link("Add a comment")
    end
  end
end

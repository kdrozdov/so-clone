require 'feature_helper'

feature 'Delete answer', %q{
  In order to remove the needless answer
  As an author of the answer
  I want to be able to delete answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'User delete his own answer', js: true do
    sign_in answer.author
    visit question_path(question)

    within '.answers' do
      click_on 'Delete'
      wait_for_ajax
      
      sleep(0.5)
      expect(current_path).to eq question_path(question)
      expect(page).not_to have_content answer.body
      expect(page).not_to have_selector "#answer-#{answer.id}"
    end
  end

  scenario "Authenticated user try to delete other user's answer" do
    sign_in user
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end

  scenario 'Non-authenticated user try to delete answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end
end

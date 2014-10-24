require 'feature_helper'

feature 'Edit answer comment', %q{
  In order to fix mistake
  As an author of the comment
  I want to be able to edit comment
} do
  
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given(:comment) { create(:comment, commentable: answer) }

  scenario 'User edit his own comment', js: true do
    sign_in comment.author
    visit question_path(answer.question)

    within '.answer' do
      within '.comment' do
        click_on 'Edit'
        fill_in 'Comment', with: 'Edited comment'
        
        click_on 'Save'
        wait_for_ajax

        expect(current_path).to eq question_path(answer.question)
        expect(page).not_to have_content comment.body
        expect(page).to have_content 'Edited comment'
        expect(page).not_to have_selector 'textarea'
      end
    end
  end

  scenario "Authenticated user try to edit other user's comment" do
    sign_in user
    visit question_path(answer.question)

    expect(page).not_to have_link 'Edit'
  end

  scenario 'Non-authenticated user try to edit comment' do
    visit question_path(answer.question)

    expect(page).not_to have_link 'Edit'
  end
end
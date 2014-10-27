require 'feature_helper'

feature 'Delete question comment', %q{
  As an author of the comment
  I want to be able to delete comment
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:comment) { create(:comment, commentable: question)}

  scenario 'User delete his own comment', js: true do
    sign_in comment.author
    visit question_path(question)

    within '.question' do
      within '.comments' do
        click_on 'Delete'
        wait_for_ajax
      
        sleep(1)
        expect(current_path).to eq question_path(question)
        expect(page).not_to have_content comment.body
        expect(page).not_to have_selector "#comment-#{comment.id}"
      end
    end
  end

  scenario "Authenticated user try to delete other user's comment" do
    sign_in user
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end

  scenario 'Non-authenticated user try to delete answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end
end
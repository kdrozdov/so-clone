require 'feature_helper'

feature 'Delete answer comment', %q{
  As an author of the comment
  I want to be able to delete comment
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given(:comment) { create(:comment, commentable: answer)}

  scenario 'User delete his own comment', js: true do
    sign_in comment.author
    visit question_path(answer.question)

    within '.answer' do
      within '.comments' do
        click_on 'Delete'
        wait_for_ajax

        sleep(1)
        expect(current_path).to eq question_path(answer.question)
        expect(page).not_to have_content comment.body
        expect(page).not_to have_selector "#comment-#{comment.id}"
      end
    end
  end

  scenario "Authenticated user try to delete other user's comment" do
    sign_in user
    visit question_path(answer.question)

    expect(page).not_to have_link 'Delete'
  end

  scenario 'Non-authenticated user try to delete answer' do
    visit question_path(answer.question)

    expect(page).not_to have_link 'Delete'
  end
end
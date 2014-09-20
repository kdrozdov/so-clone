require 'rails_helper'

feature "Create question", %q{ 
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario "Authenticated user creates question" do
    sign_in(user)
    visit new_question_path
    fill_in "Title", :with => "Question title"
    fill_in "Body", :with => "Question body"

    click_button "Create question"

    expect(page).to have_content "Your question successfully created."
    expect(page).to have_content "Question title"
    expect(page).to have_content "Question body"
  end

  scenario "Non-authenticated user tries to create question" do
    visit new_question_path

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end

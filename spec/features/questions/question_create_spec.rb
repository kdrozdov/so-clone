require 'rails_helper'

feature "Create question", %q{ 
	In order to get answer from community
	As an user
	I want to be able to ask questions
} do

  scenario "User creates question" do
    visit new_question_path

    fill_in "Title", :with => "Question title"
    fill_in "Body", :with => "Question body"

    click_button "Create question"

    expect(page).to have_text("Your question successfully created.")
    expect(page).to have_text("Question title")
    expect(page).to have_text("Question body")
  end
end

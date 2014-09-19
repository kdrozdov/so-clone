require 'rails_helper'

feature "Create answer", %q{ 
	In order to help solve the problem
	As an user
	I want to be able to answer the question
} do

  given(:question) { create(:question) }

  scenario "User creates answer" do

    visit question_path question

    fill_in "Body", :with => "Answer body"
    click_button "Create answer"

    expect(page).to have_text("Your answer successfully created.")
    expect(page).to have_text("Answer body")
  end
end

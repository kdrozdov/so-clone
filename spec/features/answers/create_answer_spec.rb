require 'rails_helper'

feature "Create answer", %q{
  In order to help solve the problem
  As an authenticated user
  I want to be able to answer the question
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario "Authenticated user creates answer", js: true do
    sign_in(user)
    visit question_path(question)

    fill_in "Your answer", :with => "My answer"
    click_on "Create answer"

    expect(current_path).to eq question_path(question)
    # expect(page).to have_text("Your answer successfully created.")
    within ".answers" do
      expect(page).to have_text("My answer")
    end
  end

  scenario "Non-authenticated user tried to create answer" do
    visit question_path(question)

    expect(page).to have_content "You should sign in or sign up to answer this question"
  end
end

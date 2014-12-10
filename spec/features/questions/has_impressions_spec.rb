require 'feature_helper'

feature "Question Has Impressions" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  background do
    sign_in user
  end
  
  scenario "Question's impressions are increased after user visiting it", js: true do
    visit root_path
    expect(page).to have_selector ".views-count", text: "0"
    visit question_path(question)
    visit root_path
    expect(page).to have_selector ".views-count", text: "1"
  end
end
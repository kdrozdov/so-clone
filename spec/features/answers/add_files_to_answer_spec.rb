require 'feature_helper'

feature 'Add files to answer', %q{
  In oreder to illustrate my answer
  As an answer's author
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:files_path) { Rails.root.join('spec/') }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when create answer', js: true do
    fill_in 'Your answer', with: 'New answer'
    click_on 'Add file'
    attach_file 'File', files_path.join('spec_helper.rb')

    click_on 'Create answer'
    wait_for_ajax

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds several files when create answer', js: true do
    fill_in 'Your answer', with: 'New answer'
    click_on 'Add file'
    click_on 'Add file'

    inputs = all('input[type="file"]')
    expect(inputs.count).to eq 2
    inputs[0].set(files_path.join('spec_helper.rb'))
    inputs[1].set(files_path.join('rails_helper.rb'))

    click_on 'Create answer'
    wait_for_ajax

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
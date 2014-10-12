require 'feature_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:files_path) { Rails.root.join('spec/') }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question', js: true do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
    click_on 'Add file'
    attach_file 'File', files_path.join('spec_helper.rb')

    click_on 'Save question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds several files when create question', js: true do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
    click_on 'Add file'
    click_on 'Add file'

    inputs = all('input[type="file"]')
    expect(inputs.count).to eq 2
    inputs[0].set(files_path.join('spec_helper.rb'))
    inputs[1].set(files_path.join('rails_helper.rb'))
    
    click_on 'Save question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
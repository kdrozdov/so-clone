# == Schema Information
#
# Table name: attachments
#
#  id                  :integer          not null, primary key
#  file                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  attachmentable_id   :integer
#  attachmentable_type :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :attachment, class: "Attachment" do
    file { fixture_file_upload(Rails.root.join('spec/support/files/test.txt')) }
    association :attachmentable
  end
end

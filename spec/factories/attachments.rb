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

FactoryGirl.define do
  factory :attachment do
    file 'MyString'
  end
end

# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#  question_id :integer
#  author_id   :integer          not null
#

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author).class_name('User') }

  it { should have_many :attachments }
  it { should have_many :comments }

  it { should validate_presence_of :body }
  
  it { should accept_nested_attributes_for :attachments }
end

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

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachmentable }
end

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

class Attachment < ActiveRecord::Base
  belongs_to :attachmentable, polymorphic: true

  mount_uploader :file, FileUploader
end

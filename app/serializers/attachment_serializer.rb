class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :filename, :file_url

  def filename
    object.file.identifier
  end
end

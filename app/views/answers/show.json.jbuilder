json.extract! @answer, :id, :question_id, :body, :created_at, :updated_at

json.attachments @answer.attachments do |attachment|
  json.id attachment.id
  json.filename attachment.file.identifier
  json.file_url attachment.file_url
end

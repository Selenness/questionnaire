class AttachmentSerializer < ActiveModel::Serializer
  attributes :link

  def link
    object.file.url
  end
end
class RenameAttachmentableTypeToAttachableType < ActiveRecord::Migration[5.0]
  def change
    rename_column :attachments, :attachmentable_type, :attachable_type
  end
end

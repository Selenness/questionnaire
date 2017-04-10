class RenameAttachmentableIdToAttachableId < ActiveRecord::Migration[5.0]
  def change
    rename_column :attachments, :attachmentable_id, :attachable_id
  end
end

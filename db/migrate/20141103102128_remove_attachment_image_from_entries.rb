class RemoveAttachmentImageFromEntries < ActiveRecord::Migration
  def change
    remove_attachment :entries, :image
  end
end

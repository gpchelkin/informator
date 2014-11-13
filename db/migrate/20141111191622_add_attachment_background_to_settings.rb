class AddAttachmentBackgroundToSettings < ActiveRecord::Migration
  def self.up
    change_table :settings do |t|
      t.attachment :background
    end
  end

  def self.down
    remove_attachment :settings, :background
  end
end

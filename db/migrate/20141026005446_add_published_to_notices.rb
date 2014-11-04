class AddPublishedToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :published, :datetime
  end
end

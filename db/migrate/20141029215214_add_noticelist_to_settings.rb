class AddNoticelistToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :noticelist, :string
  end
end

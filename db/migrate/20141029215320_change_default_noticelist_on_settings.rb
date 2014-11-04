class ChangeDefaultNoticelistOnSettings < ActiveRecord::Migration
  def change
    change_column_default :settings, :noticelist, 'config/notices.md'
  end
end

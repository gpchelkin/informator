class SetDefaultNoticelistOnSettings < ActiveRecord::Migration
  def change
    change_column_default :settings, :noticelist, 'config/notices.txt'
  end
end

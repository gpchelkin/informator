class ChangeDefaultsOnSettings < ActiveRecord::Migration
  def change
    change_column_default :settings, :mode, false
    change_column_default :settings, :frequency, 14400
    change_column_default :settings, :deprecated, 86400
    change_column_default :settings, :style, 1
    change_column_default :settings, :feedlist, 'config/feeds.txt'
  end
end

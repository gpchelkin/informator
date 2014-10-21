class Setting < ActiveRecord::Base
  after_save do |setting|
    if setting.mode_changed?
      Feed.revert_all
    end
  end

  def at # Needed by Clockwork
    nil
  end

end

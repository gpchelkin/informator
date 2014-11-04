class Setting < ActiveRecord::Base
  before_update do |setting| # Если меняем режим, сбрасываем все источники
    if setting.mode_changed?
      Feed.revert_all
    end
  end

  def at # Needed by Clockwork
    nil
  end

  def name # For Clockwork Log
    'Entry_Update_and_Cleanup_Jobs'
  end

end

class Setting < ActiveRecord::Base

  def at # Needed by Clockwork
    nil
  end

  def update_mode(smode)
    update(mode: smode)
    Feed.revert_all
  end

end

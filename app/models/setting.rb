class Setting < ActiveRecord::Base

  has_attached_file :background, styles: { medium: "300x300>", :thumb => "150x150>" }, default_url: nil
  validates_attachment_content_type :background, content_type: /\Aimage\/.*\Z/

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

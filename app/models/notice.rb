class Notice < ActiveRecord::Base

  scope :shown, -> { where(checked: true) }
  scope :unshown, -> { where(checked: false) }
  scope :desc_ord, -> { order(published: :desc) }

end

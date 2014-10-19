class Entry < ActiveRecord::Base

  scope :shown, -> { where(checked: true) }
  scope :unchecked, -> { where(checked: false) }
  scope :desc_ord, -> { order(published: :desc) }


  def self.clean_up mode=Setting.first.mode, time=Setting.first.expiration
    where("checked = ? AND published < ?", mode, Time.now-time).delete_all
  end

  def self.show_all
    unchecked.update_all(checked: true)
  end

  def self.clean_all checked
    where(checked: checked).delete_all
  end

end

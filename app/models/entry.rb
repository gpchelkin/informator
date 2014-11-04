class Entry < ActiveRecord::Base
  belongs_to :feed, inverse_of: :entries

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "150x150>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  scope :shown, -> { where(checked: true) }
  scope :unchecked, -> { where(checked: false) }
  scope :desc_ord, -> { order(published: :desc) }

  after_commit :touch_setting, on: [:destroy, :update]

  def self.clean_up mode=Setting.first.mode, time=Setting.first.expiration
    where("checked = ? AND published < ?", mode, Time.now-time).destroy_all
  end

  def self.show_all
    unchecked.update_all(checked: true)
  end

  def self.clean_all(checked = false)
    where(checked: checked).destroy_all
  end

  def to_builder
    Jbuilder.new do |entry|
      entry.(self, :title, :summary, :url)
      entry.published I18n.localize(published)
      entry.image image.url(:medium) if image.exists?
      entry.feed feed.title
    end
  end

  private
  def touch_setting
    Setting.first.touch
  end

end

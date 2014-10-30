class Notice < ActiveRecord::Base

  scope :shown, -> { where(checked: true) }
  scope :unshown, -> { where(checked: false) }
  scope :desc_ord, -> { order(published: :desc) }

  def self.load_file(noticelist = Setting.first.noticelist)
    require 'open-uri'
    delete_all
    text=""
    open(noticelist).each_line do |line|
      if line.match(/^#\s+.*$/) and not text==""
        add_from_md text
        text = ""
      end
      text += line
    end
    add_from_md text
  end

  def self.add_from_md(text="")
    notice = new
    notice.checked = false
    notice.title = text.lines.first.sub(/^#\s+/, '')
    notice.summary = Kramdown::Document.new(text, input: 'markdown').to_html
    notice.save
  end
end

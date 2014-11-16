require 'open-uri'

class Notice < ActiveRecord::Base

  scope :shown, -> { where(checked: true) }
  scope :unshown, -> { where(checked: false) }
  scope :desc_ord, -> { order(published: :desc) }

  after_commit do
    Setting.first.touch
  end

  def self.load_file(noticelist = Setting.first.noticelist)
    delete_all
    intext = false
    title = ""
    summary = ""
    open(noticelist).each_line do |line|
      if line.match(/^#\s+.*$/)
        if intext
          summarymd = Kramdown::Document.new(summary, input: 'markdown').to_html
          create(checked: false, title: title, summary: summarymd)
          title = line.sub(/^#\s+/, '')
          summary = ""
        else
          intext = true
          title = line.sub(/^#\s+/, '')
        end
      else
        if intext
          summary += line
        end
      end
    end
    summarymd = Kramdown::Document.new(summary, input: 'markdown').to_html
    create(checked: false, title: title, summary: summarymd) if intext
  end

end

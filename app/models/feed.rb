class Feed < ActiveRecord::Base
  has_many :entries, dependent: :delete_all

  before_update do |feed|
    if feed.use_changed? and not feed.use # Если выключаем источник, его записи стираются
      feed.entries.clear
      feed.last_updated = Time.at(0)
    end
  end

  def self.load_file(feedlist = Setting.first.feedlist)
    require 'open-uri'
    all.each { |feed| feed.entries.clear }
    delete_all
    open(feedlist).each_line do |line|
      feed = new
      feed.use = false
      feed.url = line.strip
      success_callback = lambda { |url, f| feed.title = f.title }
      failure_callback = lambda { |curl, err| feed.title = curl.url }
      Feedjira::Feed.fetch_and_parse feed.url, on_success: success_callback, on_failure: failure_callback
      feed.save
    end
  end

  def self.fetch_all(mode=Setting.first.mode)
    where(use: true).each { |feed| feed.fetch mode }
  end

  def self.revert_all
    all.each do |feed|
      feed.entries.clear
      feed.last_updated = Time.at(0)
      feed.save
    end
  end

  def fetch(mode=Setting.first.mode)
    success_callback = lambda do |url, f|
      f.entries.each do |entry|
        if entry.published > last_updated and not Entry.exists?(url: entry.url)
          entries.create(
              url: entry.url,
              title: entry.title,
              summary: entry.summary,
              image: entry.image,
              published: entry.published,
              checked: mode
          )
        end
      end
    end
    failure_callback = lambda { |curl, err| logger.debug err }
    Feedjira::Feed.fetch_and_parse url, on_success: success_callback, on_failure: failure_callback
    update(last_updated: Time.now)
  end

end

require 'open-uri'

class Feed < ActiveRecord::Base
  has_many :entries, dependent: :destroy, inverse_of: :feed

  before_update do |feed| # Feed is reverted when turned off
    if feed.use_changed? and not feed.use
      feed.entries.clear
      feed.last_fetched = Time.at(0)
    end
  end

  def self.load_file(feedlist = Setting.first.feedlist)
    full_sanitizer = Rails::Html::FullSanitizer.new
    all.each { |feed| feed.entries.clear }
    delete_all
    open(feedlist).each_line do |line|
      feed = new
      feed.use = false
      feed.url = line.strip
      #failure_callback = lambda { |curl, err| feed.title = curl.url }
      #success_callback = lambda { |url, f   | feed.title = full_sanitizer.sanitize(f.title) }
      Feedjira::Feed.fetch_and_parse(feed.url) #, on_success: success_callback, on_failure: failure_callback
      feed.title = full_sanitizer.sanitize(Feedjira::Feed.fetch_and_parse(feed.url).title)
      feed.save
    end
  end

  def self.fetch_all(mode=Setting.first.mode)
    where(use: true).each { |feed| feed.fetch mode }
  end

  def self.revert_all
    all.each do |feed|
      feed.entries.clear
      feed.last_fetched = Time.at(0)
      feed.save
    end
  end

  def fetch(mode=Setting.first.mode)
    full_sanitizer = Rails::Html::FullSanitizer.new
    time = [last_fetched, Time.now-Setting.first.expiration].max
    Feedjira::Feed.fetch_and_parse(url).entries.each do |entry|
      if ((not entry.published) or (entry.published > time)) and (not Entry.exists?(url: entry.url)) # For Yandex.News
        entries.create(
            url:  entry.url,
            title: full_sanitizer.sanitize(entry.title),
            summary: full_sanitizer.sanitize(entry.summary),
            image: entry.image ? URI.parse(entry.image) : nil,
            published: entry.published ? entry.published : Time.now,
            checked: mode
        )
      end
    end
    #success_callback = lambda do |url, f|
    #failure_callback = lambda { |curl, err| logger.debug err }
    #Feedjira::Feed.fetch_and_parse url, on_success: success_callback, on_failure: failure_callback
    update(last_fetched: Time.now)
    Setting.first.touch
  end

end

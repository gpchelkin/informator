class Entry < ActiveRecord::Base
  belongs_to :feed

  def self.update_all mode
    urls = Feed.where(use: true).pluck :url
    success_callback = lambda { |url, feed| add_entries(feed.entries, Feed.find_by_url(url), mode) }
    failure_callback = lambda { |curl, err| puts err }
    feeds = Feedjira::Feed.fetch_and_parse urls, on_success: success_callback, on_failure: failure_callback
  end

  def self.cleanup time
    old=where("published < ?", time)
    old.each do |entry|
      entry.destroy
    end
  end

  private
  def self.add_entries entries, feed, mode
    entries.each do |entry|
      break if exists? :entry_id => entry.id
        create(
          entry_id:     entry.id,
          feed_id:      feed.id,
          url:          entry.url,
          title:        entry.title,
          summary:      entry.summary,
          description:  entry.content,
          published:    entry.published,
          image:        entry.image,
          checked:      mode
        )
    end
  end

end

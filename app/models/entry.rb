class Entry < ActiveRecord::Base
  belongs_to :feed

  def self.update_all mode, time
    urls = Feed.where(use: true).pluck :url
    success_callback = lambda { |url, feed| add_entries(feed.entries, Feed.find_by_url(url), mode, time) }
    failure_callback = lambda { |curl, err| puts err }
    feeds = Feedjira::Feed.fetch_and_parse urls, on_success: success_callback, on_failure: failure_callback
  end

  def self.cleanup mode, time
    old = where("published < ?", time)
    if mode
      old.each {|entry| entry.destroy}
    else
      oldch = old.where(checked: true)
      oldch.each {|entry| entry.destroy}
    end
  end

  private
  def self.add_entries entries, feed, mode, time
    entries.each do |entry|
      # break if exists? :entry_id => entry.id
      break if entry.published < time # TODO Maybe Fix
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

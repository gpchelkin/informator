class Feed < ActiveRecord::Base
  has_many :entries, dependent: :delete_all

  def self.load_file(feedlist = Setting.first.feedlist)
    all.each {|feed| feed.entries.clear}
    delete_all
    IO.readlines(Rails.root.join(feedlist)).map(&:strip).each do |line|
      if line.match(/^#\s*/)
        create(use: false, url: url=line.gsub(/^#\s*/,''))
      else
        create(use: true, url: url=line)
      end
    end
    add_titles
  end

  def self.add_titles
    all.each do |feed|
      success_callback = lambda { |url, f|    feed.update(title: f.title) }
      failure_callback = lambda { |curl, err| feed.update(title: curl.url) }
      Feedjira::Feed.fetch_and_parse feed.url, on_success: success_callback, on_failure: failure_callback
    end
  end

  def self.save_file(feedlist = Setting.first.feedlist)
    File.open(Rails.root.join(feedlist), "w") do |f|
      all.each do |feed|
        f.puts (feed.use ? '' : '#') + feed.url
      end
    end
  end

  def update_use(fuse=false, ffetch=false, mode=false)
    update(use: fuse)
    revert unless use
    fetch mode if use and ffetch # Fetch on enabling
    Feed.save_file
  end

  def self.fetch_all(mode=Setting.first.mode)
    where(use: true).each {|feed| feed.fetch mode }
  end

  def self.revert_all
    all.each { |feed| feed.revert }
  end

  def fetch(mode=Setting.first.mode, exp=Setting.first.expiration)
    success_callback = lambda do |url, f|
      time = [Time.now-exp, last_updated].max
      f.entries.each do |entry|
        if entry.published > time and not Entry.exists?(url: entry.url)
          entries.create(
              url:          entry.url,
              title:        entry.title,
              summary:      entry.summary,
              image:        entry.image,
              published:    entry.published,
              checked:      mode
          )
        end
      end
    end
    failure_callback = lambda { |curl, err| puts err }
    Feedjira::Feed.fetch_and_parse url, on_success: success_callback, on_failure: failure_callback
    update(last_updated: Time.now)
  end

  def revert
    entries.clear
    update(last_updated: Time.at(0))
  end

end

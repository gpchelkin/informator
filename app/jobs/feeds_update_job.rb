class FeedsUpdateJob < ActiveJob::Base
  queue_as :default

  def perform shit
    feed=FeedSource.new
    feed.title=shit
    feed.save
  end
end

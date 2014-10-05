class FeedsUpdateJob < ActiveJob::Base
  queue_as :default

  def perform
    # TODO From Setting.feeds to FeedSource
  end
end

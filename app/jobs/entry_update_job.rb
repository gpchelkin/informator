class EntryUpdateJob < ActiveJob::Base
  queue_as :default

  def perform mode
    # TODO Fetch or update from FeedSource to Entry
  end
end

class EntryUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Feed.fetch_all
  end
end

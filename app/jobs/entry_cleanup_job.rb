class EntryCleanupJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Entry.clean_up
  end
end

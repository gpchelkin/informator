class EntryCleanupJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Entry.cleanup Time.now-Setting.first.deprecated.seconds
  end
end

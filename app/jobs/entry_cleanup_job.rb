class EntryCleanupJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Entry.cleanup Setting.first.mode, Time.now-Setting.first.expiration.seconds if Setting.first.expiration != 0
  end
end

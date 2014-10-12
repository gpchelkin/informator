class EntryUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Entry.update_all Setting.first.mode, Time.now-Setting.first.frequency.seconds
  end
end

class FeedFileLoadJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    if Feed.table_exists? and Setting.first
      Feed.file_load Rails.root.join(Setting.first.feedlist)
    end
  end
end

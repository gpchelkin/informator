class FeedFileSaveJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Feed.file_save Rails.root.join(Setting.first.feedlist)
  end
end

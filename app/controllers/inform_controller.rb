class InformController < ApplicationController
  def index
  end

  def admin
    # TODO Setting.Feed FeedsUpdateJob.perform_later     @urls = %w[http://news.yandex.ru/index.rss]    @feeds = Feedjira::Feed.fetch_and_parse @urls @feeds = Feedjira::Feed.update @feeds.values
  end
end

class WelcomeController < ApplicationController

  def index
    @urls = %w[http://news.yandex.ru/index.rss]
    @feeds = Feedjira::Feed.fetch_and_parse @urls
  end

  def upd
    @feeds = Feedjira::Feed.update @feeds.values
  end

end

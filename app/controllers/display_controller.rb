class DisplayController < ApplicationController
  include ActionController::Live

  def index

  end

  def show
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 120000, event: "entry")
    Setting.uncached do
      Entry.uncached do
        loop do
          fr = Setting.first.display_frequency
          logger.info "DB Changed or Looped."
          Entry.shown.desc_ord.each do |entry|
            sse.write entry.to_builder.target!, id: entry.id
            sleep slp = fr*(entry.title.split.size + entry.summary.split.size)
            break if Setting.first.updated_at > Time.now-slp
          end
        end
      end
    end
  rescue ClientDisconnected
    logger.info "Client Disconnected."
  ensure
    sse.close
  end

end

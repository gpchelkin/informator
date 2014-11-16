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

          logger.info "DB Changed or Looped."
          setting = Setting.first
          if Setting.first.background.exists?
            sse.write({background: "url(" + setting.background.url + ")"}, event: 'background')
          else
            sse.write({background: "#FFFFFF"}, event: 'background')
          end

          fr = setting.display_frequency
          entries = Entry.shown.desc_ord

          if entries.empty?

            sse.write({empty: "Empty"}, event: 'empty')
            sleep 10

          else

            entries.each_with_index do |entry, i|
              time = Time.now
              sse.write(entry.to_builder.target!, id: entry.id)
              sleep (entry.title.split.size + entry.summary.split.size) * fr
              break if Setting.first.updated_at > time
            end

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

class DisplayController < ApplicationController
  include ActionController::Live

  def index

  end

  def show
    @shownentries = Entry.shown
    response.headers['Content-Type'] = 'text/event-stream'
    @shownentries.each do |entry|
      response.stream.write "event: new\n"
      response.stream.write "data: #{render_to_string(json: entry)}\n\n"
      sleep 6
    end
  ensure
    response.stream.close
  end

end

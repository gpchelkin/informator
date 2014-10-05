require 'clockwork'
require './config/boot.rb'
require './config/environment.rb'

module Clockwork
  every(Setting.pause, 'EntryUpdate') {EntryUpdateJob.perform_later(Setting.mode)}
end
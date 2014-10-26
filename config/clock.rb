require 'clockwork'
require 'clockwork/database_events'
require_relative './boot.rb'
require_relative './environment.rb'

module Clockwork
  Clockwork.manager = DatabaseEvents::Manager.new
  sync_database_events model: Setting, every: 1.minute do |model_instance|
    EntryUpdateJob.perform_later
    EntryCleanupJob.perform_later if Setting.first.autocleanup
  end
end
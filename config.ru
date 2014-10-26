# This file is used by Rack-based servers to start the application.

ENV['server_mode'] = '1' # For detecting if this is a server start, see initializers/informator_loader.rb

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

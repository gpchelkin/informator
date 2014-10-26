# Load feeds only with server, not with console/rake/clockwork/dj

# if defined?(Rails::Server) # Works only for WEBrick and Thin
if ENV['server_mode'] # Works only for all Rack-based servers, set in config.ru
  Feed.load_file
end
# Load feeds only with server, not with console/rake/clockwork/dj
# if defined?(Rails::Server) # Works only for WEBrick and Thin (that start with rails s)
if ENV["SERVER_MODE"] # Works for all Rack-based servers, set in config.ru
  Feed.load_file
  Notice.load_file
end
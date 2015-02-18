# This initializer should be run only with server start, not with console/rake/clockwork/delayed_job

# if ENV["SERVER_MODE"] # Works for all Rack-based servers, set in config.ru

if defined?(Rails::Server) # Works only for servers started with rails s (e.g. WEBrick, Thin, Puma)
  Feed.load_file unless Feed.exists? # Don't reload feeds if loaded
  Notice.load_file # unless Notice.exists?
end
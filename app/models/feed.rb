class Feed < ActiveRecord::Base

  def self.file_load feedlist
    delete_all
    IO.readlines(feedlist).map(&:strip).each do |line|
      if line.match(/^#\s*/)
        create(use: false, url: url=line.gsub(/^#\s*/,''))
      else
        create(use: true, url: url=line) # TODO Add title
      end
    end
  end

  def self.file_save feedlist
    File.open(feedlist, "w") do |f|
      all.each do |feed|
        f.puts (feed.use ? '' : '#') + feed.url
      end
    end
  end

end

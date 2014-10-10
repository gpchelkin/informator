class Feed < ActiveRecord::Base

  def self.file_load filename
    delete_all
    IO.readlines(filename).map(&:strip).each do |line|
      if line.match(/^#\s*/)
        create!(use: false, url: feedurl=line.gsub(/^#\s*/,''))
      else
        create!(use: true, url: feedurl=line) # TODO Add title
      end
    end
  end

  def self.file_save filename
    File.open(filename, "w") do |f|
      all.each do |feed|
        f.puts (feed.use ? '' : '#') + feed.url
      end
    end
  end

end

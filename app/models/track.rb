require 'mp3info'

class Track
  class << self
    def root
      "#{RAILS_ROOT}/music"
    end
    
    def list
      Dir["#{root}/*"]
    end
  end
  
  attr_reader :path
  attr_reader :mp3_info
  delegate :title, :artist, :album, :comments, :to => 'mp3_info.tag'
  
  def initialize(path)
    @path = path
    raise unless File.file?(full_path)
    @mp3_info = Mp3Info.new(full_path)
  end
  
  def full_path
    "#{self.class.root}/#{path}"
  end
end

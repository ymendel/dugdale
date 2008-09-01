require 'mp3info'

class Track
  class << self
    def root
      "#{RAILS_ROOT}/music"
    end
    
    def list(path = '')
      Dir[File.join(root, path, '*')]
    end
    
    def tree(path = nil)
      path_list = list(path)
      result = list
      if path_index = result.collect { |x|  x.sub(%r%^#{Regexp.escape(Track.root)}/%, '') }.index(path)
        result[path_index+1, 0] = [path_list]
      end
      result
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

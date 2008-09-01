require 'mp3info'

class Track
  class << self
    def root
      "#{RAILS_ROOT}/music"
    end
    
    def list(path = '')
      Dir[File.join(root, path, '*')].collect do |elem|
        relative = elem.sub(%r%^#{Regexp.escape(Track.root)}/%, '')
        if File.file?(elem)
          new(relative)
        else
          relative
        end
      end
    end
    
    def tree(path = nil)
      result = list
      return result unless path
      
      path_list = list(path)        
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
    raise "#{full_path} is not a regular file" unless File.file?(full_path)
    @mp3_info = Mp3Info.new(full_path)
  end
  
  def full_path
    "#{self.class.root}/#{path}"
  end
end

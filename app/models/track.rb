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
      return list unless path
      
      path_parts = path.split('/')
      paths = (0..path_parts.length).inject([]) { |arr, i|  arr.unshift path_parts[0..i].join('/') }
      lists = paths.inject({}) { |hash, (path, _)|  hash.merge(path => list(path)) }
      
      result = nil
      lists.sort { |a,b| b.first.length <=> a.first.length }.each_cons(2) do |sub_path_info, path_info|
        sub_path, sub_path_list = sub_path_info
        path, path_list = path_info
        
        result ||= sub_path_list
        
        sub_path_end = File.split(sub_path).last
        if sub_path_index = path_list.collect { |x|  x.sub(%r%^#{Regexp.escape(Track.root)}/%, '') }.index(sub_path.split('/').last)
          tmp = path_list.dup
          tmp[sub_path_index+1, 0] = [result]
          result = tmp
        end
      end
      
      top_list = list
      if path_index = top_list.collect { |x|  x.sub(%r%^#{Regexp.escape(Track.root)}/%, '') }.index(path.split('/').first)
        result ||= list(path.split('/').first)
        tmp = top_list
        tmp[path_index+1, 0] = [result]
        result = tmp
      else
        result = top_list
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

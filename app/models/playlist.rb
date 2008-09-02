class Playlist
  class << self
    def root
      "#{RAILS_ROOT}/playlists"
    end
  end
  
  def path
    'playlist.m3u'
  end
  
  def full_path
    "#{self.class.root}/#{path}"
  end
  
  attr_reader :tracks
  
  def initialize
    load
  end
  
  def load
    @tracks = []
    contents = File.read(full_path)
    contents.split("\n").each do |line|
      @tracks << Track.new(line.sub(%r%^#{Track.root}/%, ''))
    end
  rescue Errno::ENOENT
  end
  
  def write
    File.open(full_path, 'w') do |f|
      f.puts tracks.collect(&:full_path).join("\n")
    end
  end
  
  def clear
    @tracks = []
    File.delete(full_path)
  rescue Errno::ENOENT
  end
  
  def <<(track)
    unless track.is_a?(Track)
      track = Track.new(track.sub(%r%^#{Track.root}/%, ''))
    end
    @tracks << track
  end
end

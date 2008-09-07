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
  delegate :empty?, :to => :tracks
  
  def initialize
    load
  end
  
  def load
    @tracks = []
    contents = File.read(full_path)
    contents.split("\n").each { |line|  self << line }
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
  
  def start
    return if playing?
    system("#{RAILS_ROOT}/bin/source localhost 8000 #{path} genre url irc icq aim 0 160 #{full_path} source_#{path} &")
  end
  
  def stop
    return unless p = pid
    Process.kill('TERM', p.to_i)
  end
  
  def pid
    ps_data = IO.read("| ps auxwww | grep source | grep -v grep | grep #{full_path}")
    md = ps_data.match(/^\w*\s+(\d+)/)
    return nil unless md
    md[1]
  end
  
  def playing?
    pid ? true : false
  end
end

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
end

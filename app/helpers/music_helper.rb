module MusicHelper
  def display_name(path)
    display = path
    display.sub!(%r%^#{Regexp.escape(Track.root)}/%, '')
    display.sub!(/\..*$/, '')
    display.tr!('_', ' ')
    display.sub!(/^\d+(\s*-\s*|\s+)/, '')
    display
  end
end

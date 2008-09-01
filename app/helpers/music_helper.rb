module MusicHelper
  def display_name(path)
    display = path_part(path).dup
    display.sub!(/\..*$/, '')
    display.tr!('_', ' ')
    display.sub!(/^\d+(\s*-\s*|\s+)/, '')
    display
  end
  
  def path_part(path)
    part = path.dup
    part.sub!(%r%^#{Regexp.escape(Track.root)}/%, '')
    part
  end
end
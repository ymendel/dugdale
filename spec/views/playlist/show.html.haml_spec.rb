require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. spec_helper]))

describe '/playlist/show' do
  before :each do
    @path = 'track_one'
    @track = stub('track', :path => @path)
    @track.stubs(:is_a?).with(Track).returns(true)
    @playlist = stub('playlist', :tracks => [@track])
    assigns[:playlist] = @playlist
  end
  
  def do_render
    render '/playlist/show'
  end
  
  it 'should have a track list' do
    do_render
    response.should have_tag('ol[id=?]', 'track_listing')
  end
  
  describe 'track list' do
    it 'should have a list item for the track' do
      do_render
      response.should have_tag('ol[id=?]', 'track_listing') do
        with_tag('li')
      end
    end
    
    it 'should get the track display name' do
      template.expects(:display_name).with(@track)
      do_render
    end
    
    it 'should include the track display name' do
      display_name = 'track display name'
      template.stubs(:display_name).returns(display_name)
      do_render
      response.should have_tag('ol[id=?]', 'track_listing') do
        with_tag('li', :text => Regexp.new(Regexp.escape(display_name)))
      end
    end
    
    it 'should link to the track' do
      template.stubs(:path_part).with(@track).returns('path_part')
      do_render
      response.should have_tag('ol[id=?]', 'track_listing') do
        with_tag('li') do
          with_tag('a[href=?]', '/music/show/path_part')
        end
      end
    end
    
    it 'should have a list item for every track' do
      @tracks = ['track one', 'track two']
      display_names = []
      @tracks.each do |track|
        display_name = "track '#{track}' display name"
        template.stubs(:display_name).with(track).returns(display_name)
        display_names << display_name
      end
      @playlist.stubs(:tracks).returns(@tracks)
      
      do_render
      response.should have_tag('ol[id=?]', 'track_listing') do
        @tracks.each_with_index do |track, i|
          with_tag('li', :text => display_names[i])
        end
      end
    end
    
    it 'should have no list items if there are no tracks' do
      @playlist.stubs(:tracks).returns([])
      do_render
      response.should have_tag('ol[id=?]', 'track_listing') do
        without_tag('li')
      end
    end
  end
  
  it 'should have a link to the music index' do
    do_render
    response.should have_tag('a[href=?]', '/music')
  end
  
  it 'should link to clear the playlist' do
    do_render
    response.should have_tag('a[href=?]', '/playlist/clear')
  end
end

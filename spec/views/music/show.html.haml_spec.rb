require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. spec_helper]))

describe '/music/show' do
  before :each do
    @path = 'track_one'
    @track = stub('track', :path => @path, :full_path => "#{Track.root}/#{@path}",
      :title => 'Awesome Track', :artist => 'King Awesome', :album => 'The Awesome Rides Again',
      :comments => 'Not really all that awesome.'
    )
    @track.stubs(:is_a?).with(Track).returns(true)
    assigns[:track] = @track
  end
  
  def do_render
    render '/music/show'
  end
  
  it 'should get the display name for the track' do
    template.expects(:display_name).with(@track)
    do_render
  end
  
  it 'should include the track display name' do
    display_name = 'track display name'
    template.stubs(:display_name).returns(display_name)
    do_render
    response.should have_text(Regexp.new(Regexp.escape(display_name)))
  end
  
  it 'should include the track title' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@track.title)))
  end
  
  it 'should include the track artist' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@track.artist)))
  end
  
  it 'should include the track album' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@track.album)))
  end
  
  it 'should include the track comments' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@track.comments)))
  end
  
  it 'should have a link to the music index' do
    do_render
    response.should have_tag('a[href=?]', '/music')
  end
  
  it 'should have a link to enqueue the track' do
    template.stubs(:path_part).with(@track).returns('path_part')
    do_render
    response.should have_tag('a[href=?]', '/playlist/enqueue/path_part')
  end
end

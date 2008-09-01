require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. spec_helper]))

describe '/music/show' do
  before :each do
    @path = 'track_one'
    @track = stub('track', :path => @path, :full_path => "#{Track.root}/#{@path}")
    assigns[:track] = @track
  end
  
  def do_render
    render '/music/show'
  end
  
  it 'should get the display name for the track' do
    template.expects(:display_name).with(@path)
    do_render
  end
  
  it 'should include the track display name' do
    display_name = 'track display name'
    template.stubs(:display_name).returns(display_name)
    do_render
    response.should have_text(Regexp.new(Regexp.escape(display_name)))
  end
  
  it 'should have a link to the music index' do
    do_render
    response.should have_tag('a[href=?]', '/music')
  end
end

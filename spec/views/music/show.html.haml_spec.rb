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
  
  it 'should include the track path' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@path)))
  end
  
  it 'should have a link to the music index' do
    do_render
    response.should have_tag('a[href=?]', '/music')
  end
end

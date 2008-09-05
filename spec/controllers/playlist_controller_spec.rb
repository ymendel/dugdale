require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe PlaylistController do
  describe 'GET /playlist/index' do
    def do_get
      get :index
    end
    
    it 'should redirect to show' do
      do_get
      response.should redirect_to(:action => :show)
    end
  end
  
  describe 'GET /playlist/show' do
    before :each do
      @playlist = stub('playlist')
      Playlist.stubs(:new).returns(@playlist)
    end
    
    def do_get
      get :show
    end
    
    it 'should be successful' do
      do_get
      response.should be_success
    end
    
    it 'should create a playlist instance' do
      Playlist.expects(:new)
      do_get
    end
    
    it 'should make the playlist instance available to the view' do
      do_get
      assigns[:playlist].should == @playlist
    end
    
    it 'should render the show template' do
      do_get
      response.should render_template('show')
    end
  end
end

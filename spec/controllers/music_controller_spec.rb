require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe MusicController do
  describe 'GET /music/index' do
    def do_get
      get :index
    end
    
    it 'should be successful' do
      do_get
      response.should be_success
    end
    
    it 'should get a track listing' do
      Track.expects(:list)
      do_get
    end
    
    it 'should make the track listing available to the view' do
      tracks = stub('tracks')
      Track.stubs(:list).returns(tracks)
      do_get
      assigns[:tracks].should == tracks
    end
    
    it 'should render the index template' do
      do_get
      response.should render_template('index')
    end
  end
  
  describe 'GET /music/show/path' do
    before :each do
      @path = 'track_one'
      @track = stub('track')
      Track.stubs(:new).returns(@track)
    end
    
    def do_get
      get :show, :path => @path
    end
    
    it 'should be successful' do
      do_get
      response.should be_success
    end
    
    it 'should create a track instance for the given path' do
      Track.expects(:new)
      do_get
    end
    
    it 'should make the track instance available to the view' do
      do_get
      assigns[:track].should == @track
    end
    
    it 'should render the show template' do
      do_get
      response.should render_template('show')
    end
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe MusicController do
  describe 'GET /music/index' do
    def do_get
      get :index
    end
    
    it 'should redirect to browse' do
      do_get
      response.should redirect_to(:action => :browse)
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
  
  describe 'GET /music/browse/path' do
    before :each do
      @path = 'dir'
      @tree = stub('tree')
      Track.stubs(:tree).returns(@tree)
    end
    
    def do_get
      get :browse, :path => @path
    end
    
    it 'should be successful' do
      do_get
      response.should be_success
    end
    
    it 'should get a tree for the given path' do
      Track.expects(:tree).with(@path)
      do_get
    end
    
    it 'should make the tree available to the view' do
      do_get
      assigns[:tracks].should == @tree
    end
    
    it 'should render the browse template' do
      do_get
      response.should render_template('browse')
    end
  end
  
  describe 'GET /music/browse/path (xhr)' do
    before :each do
      @path = 'dir'
      @list = stub('list')
      Track.stubs(:list).returns(@list)
    end
    
    def do_get
      xhr :get, :browse, :path => @path
    end
    
    it 'should be successful' do
      do_get
      response.should be_success
    end
    
    it 'should get a list for the given path' do
      Track.expects(:list).with(@path)
      do_get
    end
    
    it 'should make the list available to the view' do
      do_get
      assigns[:tracks].should == @list
    end
    
    it 'should render the browse template' do
      do_get
      response.should render_template('browse')
    end
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Playlist do
  before :each do
    @playlist = Playlist.new
  end
  
  describe 'as a class' do
    it 'should store the root playlist path' do
      Playlist.should respond_to(:root)
    end
    
    it "should use the 'playlists' directory in the app root as the root music path" do
      Playlist.root.should == "#{RAILS_ROOT}/playlists"
    end
  end
  
  it 'should have a path' do
    @playlist.should respond_to(:path)
  end
  
  it "should use 'playlist.m3u' as the path" do
    @playlist.path.should == 'playlist.m3u'
  end
  
  it 'should give a full path' do
    @playlist.full_path.should == "#{Playlist.root}/playlist.m3u"
  end
  
  it 'should have tracks' do
    @playlist.should respond_to(:tracks)
  end
  
  it 'should load tracks' do
    @playlist.should respond_to(:load)
  end
  
  describe 'loading tracks' do
    before :each do
      File.stubs(:read).returns('')
    end
    
    it 'should open the playlist file' do
      File.expects(:read).with(@playlist.full_path).returns('')
      @playlist.load
    end
    
    describe 'when the playlist file does not exist' do
      before :each do
        File.stubs(:read).raises(Errno::ENOENT)
      end
      
      it 'should store an empty track list' do
        @playlist.load
        @playlist.tracks.should == []
      end
    end
    
    describe 'when the playlist file exists' do
      before :each do
        @track_paths = ['track one', 'track two']
        File.stubs(:read).returns(@track_paths.join("\n"))
        @tracks = @track_paths.collect { |path|  stub("'#{path}' track") }
        @track_paths.zip(@tracks).each do |path, track|
          Track.stubs(:new).with(path).returns(track)
        end
      end
      
      it 'should make track objects for the file contents' do
        @track_paths.each do |path|
          Track.expects(:new).with(path)
        end
        @playlist.load
      end
      
      it 'should store the tracks' do
        @playlist.load
        @playlist.tracks.should == @tracks
      end
      
      it 'should strip the track root from the beginning of a line' do
        paths = @track_paths.collect { |path|  "#{Track.root}/#{path}"}
        File.stubs(:read).returns(paths.join("\n"))
        @playlist.load
        @playlist.tracks.should == @tracks
      end
      
      describe 'and is empty' do
        before :each do
          File.stubs(:read).returns('')
        end
        
        it 'should store an empty track list' do
          @playlist.load
          @playlist.tracks.should == []
        end
      end
    end
  end
  
  describe 'when initialized' do
    it 'should load tracks' do
      Playlist.any_instance.expects(:load)
      Playlist.new
    end
  end
  
  it 'should clear itself' do
    @playlist.should respond_to(:clear)
  end
  
  describe 'clearing' do
    before :each do
      @playlist.instance_variable_set('@tracks', [1,2,3,4,5])
      File.stubs(:delete)
    end
    
    it 'should clear its track list' do
      @playlist.clear
      @playlist.tracks.should == []
    end
    
    it 'should delete the playlist file' do
      File.expects(:delete).with(@playlist.full_path)
      @playlist.clear
    end
    
    describe 'when the file does not exist' do
      before :each do
        File.stubs(:delete).raises(Errno::ENOENT)
      end
      
      it 'should not error' do
        lambda { @playlist.clear }.should_not raise_error
      end
    end
  end
  
  it 'should write' do
    @playlist.should respond_to(:write)
  end
  
  describe 'writing' do
    before :each do
      @track_paths = ['track one', 'track two']
      @tracks = @track_paths.collect { |path|  stub("'#{path}' track", :full_path => path) }
      @playlist.instance_variable_set('@tracks', @tracks)
      @file = stub('file', :puts => nil)
      File.stubs(:open).yields(@file)
    end
    
    it 'should open the playlist file for writing' do
      File.expects(:open).with(@playlist.full_path, 'w')
      @playlist.write
    end
    
    it 'should write the track paths to the playlist file' do
      @file.expects(:puts).with(@track_paths.join("\n"))
      @playlist.write
    end
  end
  
  it 'should allow appending' do
    @playlist.should respond_to(:<<)
  end
  
  describe 'appending' do
    before :each do
      @playlist.clear
      @track = stub('track', :is_a? => false)
      @track.stubs(:is_a?).with(Track).returns(true)
    end
    
    it 'should add a track to the track list' do
      @playlist << @track
      @playlist.tracks.should == [@track]
    end
    
    it 'should put the track at the end of the track list' do
      @playlist.instance_variable_set('@tracks', [1,2,3])
      @playlist << @track
      @playlist.tracks.should == [1,2,3,@track]
    end
    
    describe 'given a string instead of a track' do
      before :each do
        @path = 'some_file'
        Track.stubs(:new).returns(@track)
      end
      
      it 'should make a track object for the given path' do
        Track.expects(:new).with(@path)
        @playlist << @path
      end
      
      it 'should strip the music root path from the beginning' do
        Track.expects(:new).with(@path)
        @playlist << "#{Track.root}/#{@path}"
      end
      
      it 'should add the track object to its tracks' do
        @playlist << @path
        @playlist.tracks.last == @track
      end
    end
  end
end

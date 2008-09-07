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
  
  it 'should start itself' do
    @playlist.should respond_to(:start)
  end
  
  describe 'starting' do
    it "should check if it's currently playing" do
      @playlist.expects(:playing?)
      @playlist.start
    end
    
    describe 'when not currently playing' do
      before :each do
        @playlist.stubs(:playing?).returns(false)
      end
      
      it "should shell out to the 'source' command" do
        @playlist.expects(:system).with(regexp_matches(%r%^#{RAILS_ROOT}/bin/source%))
        @playlist.start
      end
          
      it 'should provide the full path' do
        @playlist.expects(:system).with(regexp_matches(Regexp.new(Regexp.escape(@playlist.full_path))))
        @playlist.start
      end
      
      it 'should run the command in the background' do
        @playlist.expects(:system).with(regexp_matches(/&$/))
        @playlist.start
      end
    end
    
    describe 'when currently playing' do
      before :each do
        @playlist.stubs(:playing?).returns(true)
      end
      
      it 'should not run any command' do
        @playlist.expects(:sytem).never
        @playlist.start
      end
    end
  end
  
  it 'should stop itself' do
    @playlist.should respond_to(:stop)
  end
  
  describe 'stopping itself' do
    it 'should get its PID' do
      @playlist.expects(:pid)
      @playlist.stop
    end
    
    describe 'when there is a PID' do
      before :each do
        @playlist.stubs(:pid).returns('123')
      end
      
      it 'should kill that process' do
        Process.expects(:kill).with('TERM', 123)
        @playlist.stop
      end
    end
    
    describe 'when there is no PID' do
      before :each do
        @playlist.stubs(:pid).returns(nil)
      end
      
      it 'should do nothing' do
        Process.expects(:kill).never
        @playlist.stop
      end
    end
  end
  
  it 'should get its PID' do
    @playlist.should respond_to(:pid)
  end
  
  describe 'getting its PID' do
    it 'should look through the process list' do
      IO.expects(:read).with(regexp_matches(%r%^\| ps.+grep source.+grep #{@playlist.full_path}%)).returns('')
      @playlist.pid
    end
    
    describe 'when the process is found' do
      before :each do
        @pid = '4123'
        IO.stubs(:read).returns("username  #{@pid} ttys012    0:00.00 source localhost blah blah blah")
      end
      
      it 'should return the PID' do
        @playlist.pid.should == @pid
      end
    end
    
    describe 'when the process is not found' do
      before :each do
        IO.stubs(:read).returns('')
      end
      
      it 'should return nil' do
        @playlist.pid.should be_nil
      end
    end
  end
  
  it "should tell if it's currently playing" do
    @playlist.should respond_to(:playing?)
  end
  
  describe "telling if it's currently playing" do
    it 'should get its PID' do
      @playlist.expects(:pid)
      @playlist.playing?
    end
    
    describe 'when there is a PID' do
      before :each do
        @playlist.stubs(:pid).returns('123')
      end
      
      it 'should return true' do
        @playlist.playing?.should == true
      end
    end
    
    describe 'when there is no PID' do
      before :each do
        @playlist.stubs(:pid).returns(nil)
      end
      
      it 'should return false' do
        @playlist.playing?.should == false
      end
    end
  end
end

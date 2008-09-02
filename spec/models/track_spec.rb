require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Track do
  describe 'as a class' do
    it 'should store the root music path' do
      Track.should respond_to(:root)
    end
    
    it "should use the 'music' directory in the app root as the root music path" do
      Track.root.should == "#{RAILS_ROOT}/music"
    end
    
    it 'should list music' do
      Track.should respond_to(:list)
    end
    
    describe 'when listing music' do
      
      it 'should accept a path' do
        lambda { Track.list('path') }.should_not raise_error(ArgumentError)
      end
      
      it 'should not require a path' do
        lambda { Track.list }.should_not raise_error(ArgumentError)
      end
      
      it 'should get a directory listing of the given path' do
        path = 'path/to/music'
        Dir.expects(:[]).with("#{Track.root}/#{path}/*").returns([])
        Track.list(path)
      end
      
      it 'should get a directory listing of the top-level music contents if no path given' do
        Dir.expects(:[]).with("#{Track.root}/*").returns([])
        Track.list
      end
      
      it 'should return the directory listing' do
        @listing = ['file', 'other file']
        Dir.stubs(:[]).returns(@listing)
        Track.list.should == @listing
      end
      
      it 'should remove the given path from the listings' do
        @files = ['file', 'other file']
        @listing = @files.collect { |x|  "#{Track.root}/#{x}" }
        Dir.stubs(:[]).returns(@listing)
        Track.list.should == @files
      end
      
      it 'should return Track instances for the files in the directory listing' do
        @listing = ['file', 'other file']
        Dir.stubs(:[]).returns(@listing)
        File.stubs(:file?).returns(false)
        File.stubs(:file?).with('file').returns(true)
        track = stub('track')
        Track.stubs(:new).with('file').returns(track)
        Track.list.should == [track, 'other file']
      end
      
      it 'should return an empty list if the music root path does not exist' do
        Track.stubs(:root).returns('/this/path/should/not/exist')
        Track.list.should == []
      end
      
      it 'should return an empty list if the given path does not exist' do
        Track.list('/this/path/should/not/exist').should == []
      end
    end
    
    it 'should return a tree of music' do
      Track.should respond_to(:tree)
    end
    
    describe 'when returning a tree' do
      before :each do
        @path = 'dir'
        Track.stubs(:list).returns([])
      end
      
      it 'should accept a path' do
        lambda { Track.tree('path') }.should_not raise_error(ArgumentError)
      end
      
      it 'should not require a path' do
        lambda { Track.tree }.should_not raise_error(ArgumentError)
      end
      
      it 'should get the top-level list' do
        Track.expects(:list).with { |*args|  args.length.zero? }.returns([])
        Track.tree(@path)
      end
      
      it 'should get the list for the given path' do
        Track.expects(:list).with(@path).returns([])
        Track.tree(@path)
      end
      
      it 'should return the path contents nested in the top-level contents' do
        top_list = %w[ one dir two three ]
        Track.stubs(:list).returns(top_list)
        path_list = %w[ five six seven ]
        Track.stubs(:list).with(@path).returns(path_list)
        Track.tree(@path).should == ['one', 'dir', path_list, 'two', 'three']
      end
      
      it 'should not try to get path contents if no path given' do
        Track.expects(:list).once
        Track.tree
      end
      
      it 'should return only the top-level contents if no path given' do
        top_list = %w[ one dir two three ]
        Track.stubs(:list).returns(top_list)
        Track.tree.should == top_list
      end
      
      it 'should return only the top-level contents if the path contents are empty' do
        top_list = %w[ one dir two three ]
        Track.stubs(:list).returns(top_list)
        path_list = []
        Track.stubs(:list).with(@path).returns(path_list)
        Track.tree(@path).should == top_list
      end
      
      it 'should return only the top-level contents if the path does not appear in those contents' do
        top_list = %w[ one two three ]
        Track.stubs(:list).returns(top_list)
        path_list = %w[ five six seven ]
        Track.stubs(:list).with(@path).returns(path_list)
        Track.tree(@path).should == top_list
      end
      
      it 'should return the path contents nested in the top-level contents, taking the root path into account' do
        top_list = ['one', "#{Track.root}/dir", 'two', 'three' ]
        Track.stubs(:list).returns(top_list)
        path_list = %w[ five six seven ]
        Track.stubs(:list).with(@path).returns(path_list)
        Track.tree(@path).should == ['one', "#{Track.root}/dir", path_list, 'two', 'three']
      end
      
      it 'should handle sub-paths' do
        path = 'sub/path'
        top_list  = %w[one sub two three]
        Track.stubs(:list).returns(top_list)
        sub_list  = %w[five six path seven]
        Track.stubs(:list).with('sub').returns(sub_list)
        path_list = %w[eight nine ten]
        Track.stubs(:list).with('sub/path').returns(path_list)
        expected  = ['one', 'sub', ['five', 'six', 'path', ['eight', 'nine', 'ten'], 'seven'], 'two', 'three']
        Track.tree(path).should == expected
      end
      
      it 'should handle sub-sub-paths' do
        path = 'path/to/dir'
        top_list  = %w[one path two three]
        Track.stubs(:list).returns(top_list)
        path_list = %w[five six to seven]
        Track.stubs(:list).with('path').returns(path_list)
        to_list   = %w[dir eight nine ten]
        Track.stubs(:list).with('path/to').returns(to_list)
        dir_list  = %w[eleven twelve]
        Track.stubs(:list).with('path/to/dir').returns(dir_list)
        expected  = ['one', 'path', ['five', 'six', 'to', ['dir', ['eleven', 'twelve'], 'eight', 'nine', 'ten'], 'seven'], 'two', 'three']
        Track.tree(path).should == expected
      end
    end
  end
  
  describe 'when initialized' do
    before :each do
      @path = 'path/to/file'
      File.stubs(:file?).returns(true)
      Mp3Info.stubs(:new)
    end
    
    it 'should accept a path' do
      lambda { Track.new(@path) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require a path' do
      lambda { Track.new }.should raise_error(ArgumentError)
    end
    
    it 'should check if the path points to a file' do
      File.expects(:file?).with("#{Track.root}/#{@path}").returns(true)
      Track.new(@path)
    end
    
    describe 'when the path points to a file' do
      before :each do
        File.stubs(:file?).returns(true)
      end
      
      it 'should not error' do
        lambda { Track.new(@path) }.should_not raise_error
      end
      
      it 'should get mp3 info for the file' do
        Mp3Info.expects(:new).with("#{Track.root}/#{@path}")
        Track.new(@path)
      end
      
      it 'should store the mp3 info' do
        mp3 = stub('mp3')
        Mp3Info.stubs(:new).returns(mp3)
        Track.new(@path).mp3_info.should == mp3
      end
    end
    
    describe 'when the path does not point to a file' do
      before :each do
        File.stubs(:file?).returns(false)
      end
      
      it 'should error' do
        lambda { Track.new(@path) }.should raise_error
      end
      
      it 'should not get mp3 info for the file' do
        Mp3Info.expects(:new).never
        begin
          Track.new(@path)
        rescue
        end
      end
    end
    
    it 'should store the path' do
      Track.new(@path).path.should == @path
    end
    
    it 'should give a full path' do
      Track.new(@path).full_path.should == "#{Track.root}/#{@path}"
    end
  end
  
  describe 'getting info' do
    before :each do
      @mp3_tag = stub('mp3 tag')
      mp3_info = stub('mp3 info', :tag => @mp3_tag)
      Mp3Info.stubs(:new).returns(mp3_info)
      File.stubs(:file?).returns(true)
      @track = Track.new('some/path')
    end
    
    it 'should delegate title to the MP3 info' do
      title = 'some title'
      @mp3_tag.stubs(:title).returns(title)
      @track.title.should == title
    end
    
    it 'should delegate artist to the MP3 info' do
      artist = 'some artist'
      @mp3_tag.stubs(:artist).returns(artist)
      @track.artist.should == artist
    end
    
    it 'should delegate album to the MP3 info' do
      album = 'some album'
      @mp3_tag.stubs(:album).returns(album)
      @track.album.should == album
    end
    
    it 'should delegate comments to the MP3 info' do
      comments = 'comments go here'
      @mp3_tag.stubs(:comments).returns(comments)
      @track.comments.should == comments
    end
  end
end

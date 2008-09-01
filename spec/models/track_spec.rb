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
      it 'should use the root music path' do
        Track.expects(:root).returns('')
        Track.list
      end
      
      it 'should get a directory listing of the top-level music contents' do
        Dir.expects(:[]).with("#{Track.root}/*").returns([])
        Track.list
      end
      
      it 'should return the directory listing' do
        @listing = ['file', 'other file']
        Dir.stubs(:[]).returns(@listing)
        Track.list.should == @listing
      end
      
      it 'should return an empty list if the music root path does not exist' do
        Track.stubs(:root).returns('/this/path/should/not/exist')
        Track.list.should == []
      end
    end
  end
  
  describe 'when initialized' do
    before :each do
      @path = 'path/to/file'
      File.stubs(:file?).returns(true)
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
    end
    
    describe 'when the path does not point to a file' do
      before :each do
        File.stubs(:file?).returns(false)
      end
      
      it 'should error' do
        lambda { Track.new(@path) }.should raise_error
      end
    end
    
    it 'should store the path' do
      Track.new(@path).path.should == @path
    end
    
    it 'should give a full path' do
      Track.new(@path).full_path.should == "#{Track.root}/#{@path}"
    end
  end
end

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
end

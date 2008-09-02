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
  
  it 'should have tracks'
  
  it 'should load tracks'
  describe 'loading tracks' do
    it 'should open the playlist file'
    describe 'when the playlist file does not exist' do
      it 'should store an empty track list'
    end
    describe 'when the playlist file exists' do
      it 'should make track objects for the file contents'
      it 'should store the tracks'
    end
  end
  
  describe 'when initialized' do
    it 'should load tracks'
  end
  
  it 'should clear itself'
  describe 'clearing' do
    it 'should clear its track list'
    it 'should delete the playlist file'
  end
  
  it 'should write'
  describe 'writing' do
    it 'should write the track paths to the playlist file'
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe MusicHelper do
  it 'should give a display name for a track' do
    helper.should respond_to(:display_name)
  end
  
  describe 'display name' do
    it 'should accept an argument' do
      lambda { helper.display_name('filename') }.should_not raise_error(ArgumentError)
    end
    
    it 'should require an argument' do
      lambda { helper.display_name }.should raise_error(ArgumentError)
    end
    
    it 'should remove the music root path from the beginning' do
      helper.display_name("#{Track.root}/filename").should == 'filename'
    end
    
    it 'should remove the extension' do
      helper.display_name("#{Track.root}/filename.mp3").should == 'filename'
    end
    
    it 'should remove a starting track number' do
      helper.display_name("#{Track.root}/01 filename.mp3").should == 'filename'
    end
    
    it 'should remove a starting track number with a separator' do
      helper.display_name("#{Track.root}/01 - filename.mp3").should == 'filename'
    end
    
    it 'should change underscores to spaces' do
      helper.display_name("#{Track.root}/file_name").should == 'file name'
    end
    
    it 'should handle a starting track number with underscores' do
      helper.display_name("#{Track.root}/01_-_file_name.mp3").should == 'file name'
    end
    
    it 'should not change the passed-in argument' do
      arg = "#{Track.root}/filename"
      old_arg = arg.dup
      helper.display_name(arg)
      arg.should == old_arg
    end
  end
  
  it 'should give a path part for a track' do
    helper.should respond_to(:path_part)
  end
  
  describe 'path part' do
    it 'should accept an argument' do
      lambda { helper.path_part('filename') }.should_not raise_error(ArgumentError)
    end
    
    it 'should require an argument' do
      lambda { helper.path_part }.should raise_error(ArgumentError)
    end
    
    it 'should remove the music root path from the beginning' do
      helper.path_part("#{Track.root}/filename").should == 'filename'
    end
    
    it 'should not change the passed-in argument' do
      arg = "#{Track.root}/filename"
      old_arg = arg.dup
      helper.path_part(arg)
      arg.should == old_arg
    end
  end
end

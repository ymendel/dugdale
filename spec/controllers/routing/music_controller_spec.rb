require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. spec_helper]))

describe MusicController, 'routing' do
  it "should build params :action => 'index' from GET /music/index" do
    params_from(:get, '/music/index').should == { :controller => 'music', :action => 'index' }
  end
  
  it "should build params :action => 'index' from GET /music" do
    params_from(:get, '/music').should == { :controller => 'music', :action => 'index' }
  end
  
  it "should map :action => 'index' to /music" do
    route_for(:controller => 'music', :action => 'index').should == '/music'
  end
  
  it "should build params :action => 'show', :path => 'filename' from GET /music/show/filename" do
    params_from(:get, '/music/show/filename').should == { :controller => 'music', :action => 'show', :path => 'filename' }
  end
  
  it "should build params :action => 'show', :path => 'filename.mp3' from GET /music/show/filename.mp3" do
    params_from(:get, '/music/show/filename.mp3').should == { :controller => 'music', :action => 'show', :path => 'filename.mp3' }
  end
  
  it "should build params :action => 'show', :path => 'path/to/filename' from GET /music/show/path/to/filename" do
    params_from(:get, '/music/show/path/to/filename').should == { :controller => 'music', :action => 'show', :path => 'path/to/filename' }
  end
  
  it "should build params :action => 'show', :path => 'path/to/filename.mp3' from GET /music/show/path/to/filename.mp3" do
    params_from(:get, '/music/show/path/to/filename.mp3').should == { :controller => 'music', :action => 'show', :path => 'path/to/filename.mp3' }
  end
  
  it "should map :action => 'show', :path => 'filename' to /music/show/filename" do
    route_for(:controller => 'music', :action => 'show', :path => 'filename').should == '/music/show/filename'
  end
  
  it "should map :action => 'show', :path => 'filename.mp3' to /music/show/filename.mp3" do
    route_for(:controller => 'music', :action => 'show', :path => 'filename.mp3').should == '/music/show/filename.mp3'
  end
  
  it "should map :action => 'show', :path => 'path/to/filename to /music/show/path/to/filename" do
    pending 'figuring out what to do about the /s'
    route_for(:controller => 'music', :action => 'show', :path => 'path/to/filename').should == '/music/show/path/to/filename'
  end
  
  it "should map :action => 'show', :path => 'path/to/filename.mp3 to /music/show/path/to/filename.mp3" do
    pending 'figuring out what to do about the /s'
    route_for(:controller => 'music', :action => 'show', :path => 'path/to/filename.mp3').should == '/music/show/path/to/filename.mp3'
  end
end

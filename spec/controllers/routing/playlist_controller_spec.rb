require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. spec_helper]))

describe PlaylistController, 'routing' do
  it "should build params :action => 'index' from GET /playlist/index" do
    params_from(:get, '/playlist/index').should == { :controller => 'playlist', :action => 'index' }
  end
  
  it "should build params :action => 'index' from GET /playlist" do
    params_from(:get, '/playlist').should == { :controller => 'playlist', :action => 'index' }
  end
  
  it "should map :action => 'index' to /playlist" do
    route_for(:controller => 'playlist', :action => 'index').should == '/playlist'
  end
  
  it "should build params :action => 'show', from GET /playlist/show" do
    params_from(:get, '/playlist/show').should == { :controller => 'playlist', :action => 'show' }
  end
  
  it "should map :action => 'show' to /playlist/show" do
    route_for(:controller => 'playlist', :action => 'show').should == '/playlist/show'
  end
  
  it "should build params :action => 'clear', from GET /playlist/clear" do
    params_from(:get, '/playlist/clear').should == { :controller => 'playlist', :action => 'clear' }
  end
  
  it "should map :action => 'clear' to /playlist/clear" do
    route_for(:controller => 'playlist', :action => 'clear').should == '/playlist/clear'
  end
  
  it "should build params :action => 'enqueue', :path => 'filename' from GET /playlist/enqueue/filename" do
    params_from(:get, '/playlist/enqueue/filename').should == { :controller => 'playlist', :action => 'enqueue', :path => 'filename' }
  end
  
  it "should build params :action => 'enqueue', :path => 'filename.mp3' from GET /playlist/enqueue/filename.mp3" do
    params_from(:get, '/playlist/enqueue/filename.mp3').should == { :controller => 'playlist', :action => 'enqueue', :path => 'filename.mp3' }
  end
  
  it "should build params :action => 'enqueue', :path => 'path/to/filename' from GET /playlist/enqueue/path/to/filename" do
    params_from(:get, '/playlist/enqueue/path/to/filename').should == { :controller => 'playlist', :action => 'enqueue', :path => 'path/to/filename' }
  end
  
  it "should build params :action => 'enqueue', :path => 'path/to/filename.mp3' from GET /playlist/enqueue/path/to/filename.mp3" do
    params_from(:get, '/playlist/enqueue/path/to/filename.mp3').should == { :controller => 'playlist', :action => 'enqueue', :path => 'path/to/filename.mp3' }
  end
  
  it "should map :action => 'enqueue', :path => 'filename' to /playlist/enqueue/filename" do
    route_for(:controller => 'playlist', :action => 'enqueue', :path => 'filename').should == '/playlist/enqueue/filename'
  end
  
  it "should map :action => 'enqueue', :path => 'filename.mp3' to /playlist/enqueue/filename.mp3" do
    route_for(:controller => 'playlist', :action => 'enqueue', :path => 'filename.mp3').should == '/playlist/enqueue/filename.mp3'
  end
  
  it "should map :action => 'enqueue', :path => 'path/to/filename to /playlist/enqueue/path/to/filename" do
    pending 'figuring out what to do about the /s'
    route_for(:controller => 'playlist', :action => 'enqueue', :path => 'path/to/filename').should == '/playlist/enqueue/path/to/filename'
  end
  
  it "should map :action => 'enqueue', :path => 'path/to/filename.mp3 to /playlist/enqueue/path/to/filename.mp3" do
    pending 'figuring out what to do about the /s'
    route_for(:controller => 'playlist', :action => 'enqueue', :path => 'path/to/filename.mp3').should == '/playlist/enqueue/path/to/filename.mp3'
  end
  
  it "should build params :action => 'start', from GET /playlist/start" do
    params_from(:get, '/playlist/start').should == { :controller => 'playlist', :action => 'start' }
  end
  
  it "should map :action => 'start' to /playlist/start" do
    route_for(:controller => 'playlist', :action => 'start').should == '/playlist/start'
  end
  
  it "should build params :action => 'stop', from GET /playlist/stop" do
    params_from(:get, '/playlist/stop').should == { :controller => 'playlist', :action => 'stop' }
  end
  
  it "should map :action => 'stop' to /playlist/stop" do
    route_for(:controller => 'playlist', :action => 'stop').should == '/playlist/stop'
  end
end

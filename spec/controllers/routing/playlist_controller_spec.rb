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
end

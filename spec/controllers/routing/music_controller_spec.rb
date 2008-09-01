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
end

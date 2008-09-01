ActionController::Routing::Routes.draw do |map|
  map.connect 'music/show/:path', :controller => 'music', :action => 'show', :path => /.*/
  map.connect 'music/browse/:path', :controller => 'music', :action => 'browse', :path => /.*/
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

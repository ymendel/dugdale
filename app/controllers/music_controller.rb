class MusicController < ApplicationController
  def index
    redirect_to :action => :browse
  end
  
  def show
    @track = Track.new(params[:path])
  end
  
  def browse
    list_method = request.xhr? ? :list : :tree
    
    @tracks = Track.send(list_method, params[:path])
  end
end

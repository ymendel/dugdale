class MusicController < ApplicationController
  def index
    redirect_to :action => :browse
  end
  
  def show
    @track = Track.new(params[:path])
  end
  
  def browse
    @tracks = Track.tree(params[:path])
  end
end

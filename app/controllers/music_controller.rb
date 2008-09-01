class MusicController < ApplicationController
  def index
    @tracks = Track.list
  end
  
  def show
    @track = Track.new(params[:path])
  end
  
  def browse
    @tracks = Track.tree(params[:path])
  end
end

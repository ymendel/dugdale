class PlaylistController < ApplicationController
  def index
    redirect_to :action => :show
  end
  
  def show
    @playlist = Playlist.new
  end
  
  def clear
    playlist = Playlist.new
    playlist.clear
    redirect_to :action => :index
  end
  
  def enqueue
    playlist = Playlist.new
    playlist << params[:path]
    playlist.write
    
    if request.xhr?
      render :text => ''
    else
      redirect_to :action => :show
    end
  end
  
  def start
    playlist = Playlist.new
    playlist.start
    redirect_to :action => :show
  end
  
  def stop
    playlist = Playlist.new
    playlist.stop
    redirect_to :action => :show
  end
end

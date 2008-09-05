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
end

class PlaylistController < ApplicationController
  def index
    redirect_to :action => :show
  end
  
  def show
    @playlist = Playlist.new
  end
end

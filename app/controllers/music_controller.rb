class MusicController < ApplicationController
  def index
    @tracks = Track.list
  end
end

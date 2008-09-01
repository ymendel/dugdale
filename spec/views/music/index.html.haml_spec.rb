require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. spec_helper]))

describe '/music/index' do
  before :each do
    @track = 'track one'
    @tracks = [@track]
    assigns[:tracks] = @tracks
  end
  
  def do_render
    render '/music/index'
  end
  
  it 'should have a track listing' do
    do_render
    response.should have_tag('ul[id=?]', 'track_listing')
  end
  
  describe 'track listing' do
    it 'should have an item for the track' do
      do_render
      response.should have_tag('ul[id=?]', 'track_listing') do
        with_tag('li')
      end
    end
    
    it 'should have the track name in the item' do
      do_render
      response.should have_tag('ul[id=?]', 'track_listing') do
        with_tag('li', :text => @track)
      end
    end
    
    it 'should have an item for each track' do
      @tracks = ['track one', 'track two']
      assigns[:tracks] = @tracks
      do_render
      response.should have_tag('ul[id=?]', 'track_listing') do
        @tracks.each do |track|
          with_tag('li', :text => track)
        end
      end
    end
    
    it 'should have no items if there are no tracks' do
      assigns[:tracks] = []
      do_render
      response.should have_tag('ul[id=?]', 'track_listing') do
        without_tag('li')
      end
    end
  end
end

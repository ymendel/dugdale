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
    
    it 'should get the display name for the track' do
      template.expects(:display_name).with(@track)
      do_render
    end
    
    it 'should put the display name in the item' do
      display_name = 'track display name'
      template.stubs(:display_name).returns(display_name)
      do_render
      response.should have_tag('ul[id=?]', 'track_listing') do
        with_tag('li', :text => display_name)
      end
    end
    
    it 'should link to the path part of the track' do
      template.stubs(:path_part).with(@track).returns('path_part')
      do_render
      response.should have_tag('ul[id=?]', 'track_listing') do
        with_tag('li') do
          with_tag('a[href=?]', '/music/show/path_part')
        end
      end
    end
    
    it 'should have an item for each track' do
      @tracks = ['track one', 'track two']
      display_names = []
      @tracks.each do |track|
        display_name = "track '#{track}' display name"
        template.stubs(:display_name).with(track).returns(display_name)
        display_names << display_name
      end
      assigns[:tracks] = @tracks
      
      do_render
      response.should have_tag('ul[id=?]', 'track_listing') do
        @tracks.each_with_index do |track, i|
          with_tag('li', :text => display_names[i])
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

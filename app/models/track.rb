class Track
  class << self
    def root
      "#{RAILS_ROOT}/music"
    end
    
    def list
      Dir["#{root}/*"]
    end
  end
end

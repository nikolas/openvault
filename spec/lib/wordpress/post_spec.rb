require 'spec_helper'

describe Wordpress::Post do
  class MockPost < Wordpress::Post
    def initialize
    end
    def attachments
      {}
    end
  end
  
  describe '#images' do
    it 'at least returns an empty list' do
      post = MockPost.new
      expect(post.images('thumbnail')).to eq([])
    end
  end
end
require 'spec_helper'
describe HtmlStyleHelper do

  before :all do
    @hash = {'font-size' => '2em', 'background-color' => 'orange'}
    @style = "font-size:2em; background-color:orange"
  end

  describe 'hash_to_style' do
    it 'converts a hash to string appropriate for html style attribute' do
      expect(hash_to_style(@hash).gsub(/\s/, '')).to eq @style.gsub(/\s/, '')
    end
  end

  describe 'style_to_hash' do
    it 'converts an html style string into a hash of css attributes and values' do
      expect(style_to_hash(@style)).to eq @hash
    end

    it 'is the inverse of hash_to_style' do
      expect(style_to_hash(hash_to_style(@hash))).to eq @hash
    end
  end
end
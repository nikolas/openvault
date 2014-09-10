require 'spec_helper'
require 'openvault/slug_setter'

describe Openvault::SlugSetter do

  describe '#slugify' do
    it 'trims whitespace' do
      expect(Openvault::SlugSetter.slugify '  no  padding  ').to eq 'no-padding'
    end
    it 'strips non-word' do
      expect(Openvault::SlugSetter.slugify '123 !@# abc').to eq '123-abc'
    end
    it 'case normalizes' do
      expect(Openvault::SlugSetter.slugify 'UpperCase').to eq 'uppercase'
    end
  end

end
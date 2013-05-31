require 'spec_helper'

describe ApplicationHelper do
  describe '#organization_name' do
    it 'returns a string' do
      organization_name.should be_a String
    end
  end
end
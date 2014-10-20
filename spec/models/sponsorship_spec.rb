require 'spec_helper'

describe Sponsorship do

  describe 'factory' do
    it 'builds a valid instance by default (no args required)' do
      expect(build(:sponsorship)).to be_valid
    end
  end

  it 'is invalid without a user_id' do
    expect(build(:sponsorship, user_id: nil)).not_to be_valid
  end

  it 'is invalid without an artifact_id' do
    expect(build(:sponsorship, artifact_id: nil)).not_to be_valid
  end

end

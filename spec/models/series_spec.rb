require 'spec_helper'

require_relative '../factories/series'

describe Series do
  it 'has a valid factory' do
    expect(create(:series)).to be_a Series
  end
end

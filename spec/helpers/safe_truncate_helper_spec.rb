require 'spec_helper'
describe SafeTruncateHelper do
  
  it 'has a default length of 250, and breaks on spaces.' do
    long = (['gibberish']*25).join(', ')
    short = (['gibberish']*22).join(', ') + ',...'
    expect(safe_truncate(long)).to eq short
  end
  
  it 'still allows the original options' do
    long = (1..9).to_a.join('-')
    short = '1-2-3???'
    expect(safe_truncate(long, length:8, omission:'???', separator:'-')).to eq short
  end
  
  it 'strips tags' do
    expect(safe_truncate('<h1>Boo!</h1>')).to eq 'Boo!'
  end
  
  it 'has html_safe output' do
    expect(safe_truncate('string').class).to eq ActiveSupport::SafeBuffer
  end

  it 'does not choke on nil' do
    expect(safe_truncate(nil)).to eq ''
  end
  
end
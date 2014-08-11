# encoding: UTF-8
require "spec_helper"

describe "routing for Programs" do

  it 'program_path routes to program#show' do
    expect(get: program_path(123)).to route_to controller: 'programs', action: 'show', id: '123'
  end

  it 'print_program_path routes to program#print' do
    expect(get: print_program_path(123)).to route_to controller: 'programs', action: 'print', id: '123'
  end

end
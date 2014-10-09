require "spec_helper"

describe '/blog', type: :request do
  it 'redirects to blog.openvault.wgbh.org' do
    path = '/foo'
    get "/blog#{path}"
    expect(response).to redirect_to("http://blog.openvault.wgbh.org#{path}")
  end
end
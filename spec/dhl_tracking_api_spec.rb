require 'spec_helper'
require 'fixtures'

RSpec.describe DhlTrackingApi do

  subject(:response) { DhlTrackingApi.new.request('12345') }

  before do
    stub_request(:get, demo_request).to_return(body: demo_response)
  end


  it do
    expect(response.raw_response.body).to eql demo_response
  end

  it do
    expect(response.errors?).to be_falsy
  end

  it do
    expect(response.error_message).to be_nil
  end


  # it { is_expected.not_to be_empty }

end


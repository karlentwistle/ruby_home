require 'spec_helper'

require_relative '../../../lib/rubyhome/hap/builders/accessory_information_builder'
require_relative '../../../lib/rubyhome/hap/builders/fan_builder'

RSpec.describe 'GET /accessories' do
  context 'Request denied due to insufficient privileges' do
    before do
      get '/accessories', nil, {'CONTENT_TYPE' => 'application/hap+json'}
    end

    it 'headers contains application/hap+json' do
      expect(last_response.headers).to include('Content-Type' => 'application/hap+json')
    end

    it 'response status 401' do
      expect(last_response.status).to eql(401)
    end

    it 'response body includes status' do
      expect(last_response.body).to eql('{"status":-70401}')
    end
  end

  context 'Sufficient privileges and no error occurs' do
    before do
      create_accessory

      set_cache(:controller_to_accessory_key, ['a' * 64].pack('H*'))
      set_cache(:accessory_to_controller_key, ['b' * 64].pack('H*'))
      get '/accessories', nil, {'CONTENT_TYPE' => 'application/hap+json'}
    end

    it 'headers contains application/hap+json' do
      expect(last_response.headers).to include('Content-Type' => 'application/hap+json')
    end

    it 'response status 200' do
      expect(last_response.status).to eql(200)
    end

    it 'responds with accessories' do
      path = File.expand_path('../../../fixtures/accessories_json/fan.json', __FILE__)
      data = File.read(path)
      expect(JSON.parse(last_response.body)).to eql(JSON.parse(data))
    end
  end

  def create_accessory
    information = Rubyhome::AccessoryInformationBuilder.new
    fan = Rubyhome::FanBuilder.new

    information.save
    fan.save
  end
end

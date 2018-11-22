require 'spec_helper'

RSpec.describe RubyHome::HAP::HAPResponse do
  let(:key) { ['273dc7c4e1cfdac3cb78dce01709f93208e6d3236171b58f4a28d8e5e73ee895'].pack('H*') }
  let(:io) { StringIO.new }
  let(:config) { WEBrick::Config::HTTP.dup.update(ServerSoftware: 'WEBrick') }
  let(:session) { RubyHome::HAP::Session.new(io) }
  subject(:hap_response) { RubyHome::HAP::HAPResponse.new(config) }

  before do
    session.accessory_to_controller_key = key
  end

  describe '#send_response' do
    context 'encryption_time' do
      it 'returns an encrypted response' do
        session.controller_to_accessory_count = 1
        hap_response['date'] = Time.new(2018).httpdate

        hap_response.send_response(session)
        io.rewind

        actual_response = io.read.unpack1('H*')
        expected_response = %w{
          7500582B D036C460 C52BB498 B08E68D4 4673C44D A7555806 1CEEC113 FA20192E
          E76772F9 5C50692E C56F08F0 CC0AEF41 1DB57370 CB5F0A87 562D708E 2D65683A
          9AE83033 D93BD2D2 1C4CF3A4 FABA7B1A C2AEDC98 D3715229 F86E380C 812F3057
          FD8C8005 3CB059CC CD4DADDD B1A08BA7 41DBF76E 7FE4568B E9203223 3F7E793F
          91EC6B4E FFCE0C
        }.join.downcase
        expect(actual_response).to eql(expected_response)
      end
    end

    context 'not encryption_time' do
      it 'returns an unencrypted response' do
        hap_response['date'] = Time.new(2018).httpdate

        hap_response.send_response(session)
        io.rewind

        expected_response = <<~RESPONSE
          HTTP/1.1 200 OK \x0d
          Date: Mon, 01 Jan 2018 00:00:00 GMT\x0d
          Server: WEBrick\x0d
          Content-Length: 0\x0d
          Connection: Keep-Alive\x0d
          \x0d
        RESPONSE
        expect(io.read).to eql(expected_response)
      end
    end
  end
end


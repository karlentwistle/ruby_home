require 'spec_helper'

RSpec.describe 'POST /pair-verify' do
  context 'Verify Start Response' do
    context 'Sufficient privileges and no error occurs' do
      before do
        stub_secret_key = RbNaCl::PrivateKey.new(['0000000000000000000000000000000000000000000000000000000000000040'].pack('H*'))
        allow(RbNaCl::PrivateKey).to receive(:generate).and_return(stub_secret_key)

        RubyHome::AccessoryInfo.instance.add_paired_client(
          admin: true,
          identifier: '349CBC7D-01B9-4DC4-AD98-FB9029BB77F2',
          public_key: '62398c58854a0718b19a64445f5f63761472802dd15ddf19cc74bee253dde525'
        )

        path = File.expand_path('../../../fixtures/verify_start_response', __FILE__)
        data = File.read(path)
        post '/pair-verify', data, { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
      end

      it 'headers contains application/pairing+tlv8 header' do
        expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
      end

      it 'body contains state' do
        expect(unpacked_body).to include(state: 2)
      end

      it 'body contains public_key' do
        public_key = unpacked_body[:public_key].unpack1('H*')
        expected_public_key = %w{
          2FE57DA3 47CD6243 1528DAAC 5FBB2907 30FFF684 AFC4CFC2 ED90995F 58CB3B74
        }.join.downcase
        expect(public_key).to eql(expected_public_key)
      end

      it 'body contains encrypted_data' do
        encrypted_data = unpacked_body[:encrypted_data].unpack1('H*')
        expected_encrypted_data = %w{
          A1A9D22A D4DA0E65 EECCA820 A1872E4D 0F8EEAB6 38E37B44 A2228A43 4C305DAB
          AD057CD1 CD65B0C5 837DD92A 4B640CD7 D810D249 E666CAB1 3938CA59 FACB891C
          D7F5657E 6D2021E3 E2DF7ED0 7F0F14B5 7C3B5811 9869AFE1 5EE3C917 3F33D27A
          53923E4B 45
        }.join.downcase

        expect(encrypted_data).to eql(expected_encrypted_data)
      end
    end

    context 'No paired devices' do
      it "doesnt allow pair-verify without being paired first" do
        post '/pair-verify', tlv_encode(state: 2), { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
        expect(last_response.status).to eql(403)
      end
    end
  end

  context 'Verify Finish Response' do
    let(:path) { File.expand_path('../../../fixtures/verify_finish_response', __FILE__) }
    let(:data) { File.read(path) }

    before do
      session.session_key = ['d741e4ecbf9868e86aab782ddc03ed75767bfc30634a15dabcc895bace33e57e'].pack('H*')
      session.shared_secret = ['4bdd6daf9eb979012962fd0ab33a58c528784cf15ac724d213e494b1ca744e02'].pack('H*')
    end

    context 'iOSDevicePairingID exists in list of paired controllers.' do
      before do
        RubyHome::AccessoryInfo.instance.add_paired_client(
          admin: true,
          identifier: '349CBC7D-01B9-4DC4-AD98-FB9029BB77F2',
          public_key: '62398c58854a0718b19a64445f5f63761472802dd15ddf19cc74bee253dde525'
        )
      end

      it 'headers contains application/pairing+tlv8 header' do
        post '/pair-verify', data, { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
        expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
      end

      it 'body contains only state: 4' do
        post '/pair-verify', data, { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
        expect(unpacked_body).to eql(state: 4)
      end

      it 'destroys cached shared_secret' do
        post '/pair-verify', data, { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
        expect(session.shared_secret).to be_nil
      end

      it 'destroys cached session_key' do
        post '/pair-verify', data, { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
        expect(session.session_key).to be_nil
      end
    end

    context 'iOSDevicePairingID does not exists in list of paired controllers.' do
      before do
        RubyHome::AccessoryInfo.instance.add_paired_client(
          admin: true,
          identifier: 'foo',
          public_key: 'foo'
        )
      end

      it 'headers contains application/pairing+tlv8 header' do
        post '/pair-verify', data, { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
        expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
      end

      it 'body contains only state: 4 and error: 2' do
        post '/pair-verify', data, { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
        expect(unpacked_body).to eql(state: 4, error: 2)
      end
    end

    context 'No paired devices' do
      it "doesnt allow pair-verify without being paired first" do
        post '/pair-verify', tlv_encode(state: 2), { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
        expect(last_response.status).to eql(403)
      end
    end
  end
end

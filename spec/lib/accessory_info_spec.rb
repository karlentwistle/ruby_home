require 'spec_helper'

RSpec.describe RubyHome::AccessoryInfo do
  describe '.username' do
    it 'returns Pair-Setup' do
      expect(RubyHome::AccessoryInfo.username).to eql('Pair-Setup')
    end
  end

  describe '.password' do
    it 'returns 031-45-154' do
      expect(RubyHome::AccessoryInfo.password).to eql('031-45-154')
    end
  end

  describe '.signing_key' do
    it 'returns a Ed25519::SigningKey' do
      expect(RubyHome::AccessoryInfo.signing_key).to be_a(RbNaCl::Signatures::Ed25519::SigningKey)
    end
  end

  describe '.device_id' do
    it 'returns a device_id' do
      device_id = double
      expect(RubyHome::DeviceID).to receive(:generate).and_return(device_id)
      RubyHome::AccessoryInfo.pstore = PStore.new(Tempfile.new)
      expect(RubyHome::AccessoryInfo.device_id).to eql(device_id)
    end
  end

  describe '.paired_clients' do
    it 'returns a empty array' do
      expect(RubyHome::AccessoryInfo.paired_clients).to be_empty
    end
  end

  describe '.paired?' do
    context 'no paired clients' do
      it 'returns false' do
        expect(RubyHome::AccessoryInfo).not_to be_paired
      end
    end

    context 'has paired clients' do
      it 'returns true' do
        RubyHome::AccessoryInfo.add_paired_client({identifier: double, public_key: double})
        expect(RubyHome::AccessoryInfo).to be_paired
      end
    end
  end

  describe '.add_paired_client' do
    it 'adds a client to paired_clients' do
      public_key = double
      identifier = double
      RubyHome::AccessoryInfo.add_paired_client({identifier: identifier, public_key: public_key})
      expect(RubyHome::AccessoryInfo.paired_clients).to match(
        a_hash_including(
          admin: false,
          identifier: identifier,
          public_key: public_key
        )
      )
    end
  end
end

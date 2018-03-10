require 'spec_helper'

RSpec.describe Rubyhome::AccessoryInfo do
  describe '.username' do
    it 'returns Pair-Setup' do
      expect(Rubyhome::AccessoryInfo.username).to eql('Pair-Setup')
    end
  end

  describe '.password' do
    it 'returns 031-45-154' do
      expect(Rubyhome::AccessoryInfo.password).to eql('031-45-154')
    end
  end

  describe '.signing_key' do
    it 'returns a Ed25519::SigningKey' do
      expect(Rubyhome::AccessoryInfo.signing_key).to be_a(Ed25519::SigningKey)
    end
  end

  describe '.device_id' do
    it 'returns a device_id' do
      device_id = double
      expect(Rubyhome::DeviceID).to receive(:generate).and_return(device_id)
      Rubyhome::AccessoryInfo.pstore = PStore.new(Tempfile.new)
      expect(Rubyhome::AccessoryInfo.device_id).to eql(device_id)
    end
  end

  describe '.paired_clients' do
    it 'returns a empty array' do
      expect(Rubyhome::AccessoryInfo.paired_clients).to be_empty
    end
  end

  describe '.paired?' do
    context 'no paired clients' do
      it 'returns false' do
        expect(Rubyhome::AccessoryInfo).not_to be_paired
      end
    end

    context 'has paired clients' do
      it 'returns true' do
        Rubyhome::AccessoryInfo.add_paired_client({identifier: double, public_key: double})
        expect(Rubyhome::AccessoryInfo).to be_paired
      end
    end
  end

  describe '.add_paired_client' do
    it 'adds a client to paired_clients' do
      public_key = double
      identifier = double
      Rubyhome::AccessoryInfo.add_paired_client({identifier: identifier, public_key: public_key})
      expect(Rubyhome::AccessoryInfo.paired_clients).to match(
        a_hash_including(
          admin: false,
          identifier: identifier,
          public_key: public_key
        )
      )
    end
  end
end

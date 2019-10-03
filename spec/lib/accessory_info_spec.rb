require 'spec_helper'

RSpec.describe RubyHome::AccessoryInfo do
  subject(:instance) { RubyHome::AccessoryInfo.instance }

  describe '#username' do
    it 'returns Pair-Setup' do
      expect(instance.username).to eql('Pair-Setup')
    end
  end

  describe '#password' do
    it 'returns 031-45-154' do
      expect(instance.password).to eql('031-45-154')
    end

    it 'returns customised password if it\'s been set' do
      instance.password = '999-66-333'
      expect(instance.password).to eql('999-66-333')
    end

    it 'persists customised password' do
      instance.password = '999-66-333'
      instance.reload

      expect(RubyHome::AccessoryInfo.persisted.password).to eql('999-66-333')
    end
  end

  describe '#signing_key' do
    it 'returns a Ed25519::SigningKey' do
      expect(instance.signing_key).to be_a(RbNaCl::Signatures::Ed25519::SigningKey)
    end
  end

  describe '#device_id' do
    it 'returns a device_id' do
      expect(instance.device_id).to eql(EXAMPLE_DEVICE_ID)
    end
  end

  describe '#paired_clients' do
    it 'returns a empty array' do
      expect(instance.paired_clients).to be_empty
    end
  end

  describe '#paired?' do
    context 'no paired clients' do
      it 'returns false' do
        expect(instance).not_to be_paired
      end
    end

    context 'has paired clients' do
      it 'returns true' do
        instance.add_paired_client({identifier: double, public_key: double})
        expect(instance).to be_paired
      end
    end
  end

  describe '#add_paired_client' do
    it 'adds a client to paired_clients' do
      public_key = 'public_key'
      identifier = 'identifier'
      instance.add_paired_client({identifier: identifier, public_key: public_key})
      expect(instance.paired_clients).to match(
        a_hash_including(
          admin: false,
          identifier: identifier,
          public_key: public_key
        )
      )
    end
  end
end

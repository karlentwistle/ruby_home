require 'spec_helper'

RSpec.describe RubyHome::HAP::TLV do
  describe '.read' do
    subject do
      described_class.read([input].pack('H*'))
    end

    context 'kTLVType_Method' do
      let(:input) { '0001ff' }
      it { is_expected.to eql({'kTLVType_Method' => 255}) }
    end

    context 'kTLVType_Identifier' do
      let(:input) { '010568656c6c6f' }
      it { is_expected.to eql({'kTLVType_Identifier' => 'hello'}) }
    end

    context 'kTLVType_Identifier unicode character' do
      let(:input) { '0103e29087' }
      it { is_expected.to eql({'kTLVType_Identifier' => '␇'}) }
    end

    context 'kTLVType_Salt' do
      let(:input) { '0210c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({'kTLVType_Salt' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')}) }
    end

    context 'kTLVType_PublicKey' do
      let(:input) { '030a596ffa328760d19e7b9d' }
      it { is_expected.to eql({'kTLVType_PublicKey' => hex_string('596ffa328760d19e7b9d')}) }
    end

    context 'kTLVType_Proof' do
      let(:input) { '04020fab' }
      it { is_expected.to eql({'kTLVType_Proof' => hex_string('0fab')}) }
    end

    context 'kTLVType_EncryptedData' do
      let(:input) { '050449625160' }
      it { is_expected.to eql({'kTLVType_EncryptedData' => hex_string('49625160')}) }
    end

    context 'kTLVType_State' do
      let(:input) { '060100' }
      it { is_expected.to eql({'kTLVType_State' => 0}) }
    end

    context 'kTLVType_Error' do
      let(:input) { '07010f' }
      it { is_expected.to eql({'kTLVType_Error' => 15}) }
    end

    context 'kTLVType_RetryDelay' do
      let(:input) { '0801aa' }
      it { is_expected.to eql({'kTLVType_RetryDelay' => 170}) }
    end

    context 'kTLVType_Certificate' do
      let(:input) { '0910c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({'kTLVType_Certificate' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')}) }
    end

    context 'kTLVType_Signature' do
      let(:input) { '0a10c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({'kTLVType_Signature' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')}) }
    end

    context 'kTLVType_Permissions' do
      let(:input) { '0B0112' }
      it { is_expected.to eql({'kTLVType_Permissions' => 18}) }
    end

    context 'kTLVType_FragmentData' do
      let(:input) { '0c10c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({'kTLVType_FragmentData' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')}) }
    end

    context 'kTLVType_FragmentLast' do
      let(:input) { '0d10c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({'kTLVType_FragmentLast' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')}) }
    end

    context '2 small TLVs Integer and Integer' do
      let(:input) { '0001ff07010f' }
      it { is_expected.to eql({'kTLVType_Method' => 255, 'kTLVType_Error' => 15}) }
    end

    context '2 small TLVs Integer and ASCII' do
      let(:input) { '060103010568656c6c6f' }
      it { is_expected.to eql({'kTLVType_State' => 3, 'kTLVType_Identifier' => 'hello'}) }
    end

    context '1 small TLV, 1 300-byte value split into 2 TLVs, 1 small TLV' do
      let(:input) do
        '0701030aff616161616161616161616161616161616161616161616161616161616161'\
        '6161616161616161616161616161616161616161616161616161616161616161616161'\
        '6161616161616161616161616161616161616161616161616161616161616161616161'\
        '6161616161616161616161616161616161616161616161616161616161616161616161'\
        '6161616161616161616161616161616161616161616161616161616161616161616161'\
        '6161616161616161616161616161616161616161616161616161616161616161616161'\
        '6161616161616161616161616161616161616161616161616161616161616161616161'\
        '6161616161616161616161616161610a2d616161616161616161616161616161616161'\
        '616161616161616161616161616161616161616161616161616161010568656c6c6f'\
      end
      it do
        is_expected.to eql({
          'kTLVType_Error' => 3,
          'kTLVType_Signature' => hex_string('61' * 300),
          'kTLVType_Identifier' => 'hello'
        })
      end
    end
  end

  describe '.encode' do
    subject { described_class.encode(input) }

    context 'kTLVType_Method' do
      let(:input) { {'kTLVType_Method' => 255} }
      it { is_expected.to eql(['0001ff'].pack('H*')) }
    end

    context 'kTLVType_Identifier' do
      let(:input) { {'kTLVType_Identifier' => 'hello'} }
      it { is_expected.to eql(['010568656c6c6f'].pack('H*')) }
    end

    context 'kTLVType_Identifier unicode character' do
      let(:input) { {'kTLVType_Identifier' => '␇'} }
      it { is_expected.to eql(['0103e29087'].pack('H*')) }
    end

    context 'kTLVType_Salt' do
      let(:input) { {'kTLVType_Salt' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')} }
      it { is_expected.to eql(['0210c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'kTLVType_PublicKey' do
      let(:input) { {'kTLVType_PublicKey' => hex_string('596ffa328760d19e7b9d')} }
      it { is_expected.to eql(['030a596ffa328760d19e7b9d'].pack('H*')) }
    end

    context 'kTLVType_Proof' do
      let(:input) { {'kTLVType_Proof' => hex_string('0fab')} }
      it { is_expected.to eql(['04020fab'].pack('H*')) }
    end

    context 'kTLVType_EncryptedData' do
      let(:input) { {'kTLVType_EncryptedData' => hex_string('49625160')} }
      it { is_expected.to eql(['050449625160'].pack('H*')) }
    end

    context 'kTLVType_State' do
      let(:input) { {'kTLVType_State' => 0} }
      it { is_expected.to eql(['060100'].pack('H*')) }
    end

    context 'kTLVType_Error' do
      let(:input) { {'kTLVType_Error' => 15} }
      it { is_expected.to eql(['07010f'].pack('H*')) }
    end

    context 'kTLVType_RetryDelay' do
      let(:input) { {'kTLVType_RetryDelay' => 170} }
      it { is_expected.to eql(['0801aa'].pack('H*')) }
    end

    context 'kTLVType_Certificate' do
      let(:input) { {'kTLVType_Certificate' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')} }
      it { is_expected.to eql(['0910c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'kTLVType_Signature' do
      let(:input) { {'kTLVType_Signature' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')} }
      it { is_expected.to eql(['0a10c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'kTLVType_Permissions' do
      let(:input) { {'kTLVType_Permissions' => 18} }
      it { is_expected.to eql(['0B0112'].pack('H*')) }
    end

    context 'kTLVType_FragmentData' do
      let(:input) { {'kTLVType_FragmentData' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')} }
      it { is_expected.to eql(['0c10c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'kTLVType_FragmentLast' do
      let(:input) { {'kTLVType_FragmentLast' => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')} }
      it { is_expected.to eql(['0d10c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context '2 small TLVs Integer and Integer' do
      let(:input) { {'kTLVType_Method' => 255, 'kTLVType_Error' => 15} }
      it { is_expected.to eql(['0001ff07010f'].pack('H*')) }
    end

    context '2 small TLVs Integer and ASCII' do
      let(:input) { {'kTLVType_State' => 3, 'kTLVType_Identifier' => 'hello'} }
      it { is_expected.to eql(['060103010568656c6c6f'].pack('H*')) }
    end

    context '1 small TLV, 1 300-byte value split into 2 TLVs, 1 small TLV' do
      let(:input) do
        {
          'kTLVType_Error' => 3,
          'kTLVType_Signature' => hex_string('61' * 300),
          'kTLVType_Identifier' => 'hello'
        }
      end
      it do
        is_expected.to eql([
          '0701030aff616161616161616161616161616161616161616161616161616161616161'\
          '6161616161616161616161616161616161616161616161616161616161616161616161'\
          '6161616161616161616161616161616161616161616161616161616161616161616161'\
          '6161616161616161616161616161616161616161616161616161616161616161616161'\
          '6161616161616161616161616161616161616161616161616161616161616161616161'\
          '6161616161616161616161616161616161616161616161616161616161616161616161'\
          '6161616161616161616161616161616161616161616161616161616161616161616161'\
          '6161616161616161616161616161610a2d616161616161616161616161616161616161'\
          '616161616161616161616161616161616161616161616161616161010568656c6c6f'
        ].pack('H*'))
      end
    end
  end

  def hex_string(input)
    [input].pack('H*')
  end
end

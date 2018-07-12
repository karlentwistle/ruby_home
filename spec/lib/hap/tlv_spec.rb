require 'spec_helper'

RSpec.describe RubyHome::HAP::TLV do
  describe '.read' do
    subject do
      described_class.read([input].pack('H*'))
    end

    context 'method' do
      let(:input) { '0001ff' }
      it { is_expected.to eql({:method => 255}) }
    end

    context 'identifier' do
      let(:input) { '010568656c6c6f' }
      it { is_expected.to eql({:identifier => 'hello'}) }
    end

    context 'kTLVType_Identifier unicode character' do
      let(:input) { '0103e29087' }
      it { is_expected.to eql({:identifier => '␇'}) }
    end

    context 'salt' do
      let(:input) { '0210c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({:salt => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')}) }
    end

    context 'public_key' do
      let(:input) { '030a596ffa328760d19e7b9d' }
      it { is_expected.to eql({:public_key => hex_string('596ffa328760d19e7b9d')}) }
    end

    context 'proof' do
      let(:input) { '04020fab' }
      it { is_expected.to eql({:proof => hex_string('0fab')}) }
    end

    context 'encrypted_data' do
      let(:input) { '050449625160' }
      it { is_expected.to eql({:encrypted_data => hex_string('49625160')}) }
    end

    context 'state' do
      let(:input) { '060100' }
      it { is_expected.to eql({:state => 0}) }
    end

    context 'error' do
      let(:input) { '07010f' }
      it { is_expected.to eql({:error => 15}) }
    end

    context 'retry_delay' do
      let(:input) { '0801aa' }
      it { is_expected.to eql({:retry_delay => 170}) }
    end

    context 'certificate' do
      let(:input) { '0910c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({:certificate => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')}) }
    end

    context 'signature' do
      let(:input) { '0a10c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({:signature => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')}) }
    end

    context 'permissions' do
      let(:input) { '0B0112' }
      it { is_expected.to eql({:permissions => 18}) }
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
      it { is_expected.to eql({:method => 255, :error => 15}) }
    end

    context '2 small TLVs Integer and ASCII' do
      let(:input) { '060103010568656c6c6f' }
      it { is_expected.to eql({:state => 3, :identifier => 'hello'}) }
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
          :error => 3,
          :signature => hex_string('61' * 300),
          :identifier => 'hello'
        })
      end
    end

    context 'unrecognized types' do
      let(:input) { '0f01ff' }
      it 'TLV items with unrecognized types must be silently ignored' do
        is_expected.to eql({})
      end
    end

    context 'TLV item length' do
      let(:input) { '0100' }
      it '0 is a valid length' do
        is_expected.to eql({:identifier => ''})
      end
    end
  end

  describe '.encode' do
    subject { described_class.encode(input) }

    context 'method' do
      let(:input) { {:method => 255} }
      it { is_expected.to eql(['0001ff'].pack('H*')) }
    end

    context 'identifier' do
      let(:input) { {:identifier => 'hello'} }
      it { is_expected.to eql(['010568656c6c6f'].pack('H*')) }
    end

    context 'kTLVType_Identifier unicode character' do
      let(:input) { {:identifier => '␇'} }
      it { is_expected.to eql(['0103e29087'].pack('H*')) }
    end

    context 'salt' do
      let(:input) { {:salt => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')} }
      it { is_expected.to eql(['0210c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'public_key' do
      let(:input) { {:public_key => hex_string('596ffa328760d19e7b9d')} }
      it { is_expected.to eql(['030a596ffa328760d19e7b9d'].pack('H*')) }
    end

    context 'proof' do
      let(:input) { {:proof => hex_string('0fab')} }
      it { is_expected.to eql(['04020fab'].pack('H*')) }
    end

    context 'encrypted_data' do
      let(:input) { {:encrypted_data => hex_string('49625160')} }
      it { is_expected.to eql(['050449625160'].pack('H*')) }
    end

    context 'state' do
      let(:input) { {:state => 0} }
      it { is_expected.to eql(['060100'].pack('H*')) }
    end

    context 'error' do
      let(:input) { {:error => 15} }
      it { is_expected.to eql(['07010f'].pack('H*')) }
    end

    context 'retry_delay' do
      let(:input) { {:retry_delay => 170} }
      it { is_expected.to eql(['0801aa'].pack('H*')) }
    end

    context 'certificate' do
      let(:input) { {:certificate => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')} }
      it { is_expected.to eql(['0910c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'signature' do
      let(:input) { {:signature => hex_string('c8eb453673a905cc5ca6b64ce85e22e9')} }
      it { is_expected.to eql(['0a10c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'permissions' do
      let(:input) { {:permissions => 18} }
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
      let(:input) { {:method => 255, :error => 15} }
      it { is_expected.to eql(['0001ff07010f'].pack('H*')) }
    end

    context '2 small TLVs Integer and ASCII' do
      let(:input) { {:state => 3, :identifier => 'hello'} }
      it { is_expected.to eql(['060103010568656c6c6f'].pack('H*')) }
    end

    context '1 small TLV, 1 300-byte value split into 2 TLVs, 1 small TLV' do
      let(:input) do
        {
          :error => 3,
          :signature => hex_string('61' * 300),
          :identifier => 'hello'
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

    context 'unrecognized types' do
      let(:input) { {'kTLVType_Unrecognized' => 3 } }
      it 'TLV items with unrecognized types must be silently ignored' do
        is_expected.to eql('')
      end
    end

    context 'TLV item length' do
      let(:input) { {:identifier => ''} }
      it '0 is a valid length' do
        is_expected.to eql('')
      end
    end
  end

  def hex_string(input)
    [input].pack('H*')
  end
end

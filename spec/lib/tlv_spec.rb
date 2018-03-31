require 'spec_helper'
require_relative '../../lib/ruby_home/tlv'

RSpec.describe RubyHome::TLV do
  describe '.unpack' do
    subject do
      described_class.unpack([input].pack('H*'))
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
      let(:input) { '0105e29087' }
      it { is_expected.to eql({'kTLVType_Identifier' => '␇'}) }
    end

    context 'kTLVType_Salt' do
      let(:input) { '0210c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({'kTLVType_Salt' => 'c8eb453673a905cc5ca6b64ce85e22e9'}) }
    end

    context 'kTLVType_PublicKey' do
      let(:input) { '030a596ffa328760d19e7b9d' }
      it { is_expected.to eql({'kTLVType_PublicKey' => '596ffa328760d19e7b9d'}) }
    end

    context 'kTLVType_Proof' do
      let(:input) { '04020fab' }
      it { is_expected.to eql({'kTLVType_Proof' => '0fab'}) }
    end

    context 'kTLVType_EncryptedData' do
      let(:input) { '050449625160' }
      it { is_expected.to eql({'kTLVType_EncryptedData' => '49625160'}) }
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
      it { is_expected.to eql({'kTLVType_Certificate' => 'c8eb453673a905cc5ca6b64ce85e22e9'}) }
    end

    context 'kTLVType_Signature' do
      let(:input) { '0a10c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({'kTLVType_Signature' => 'c8eb453673a905cc5ca6b64ce85e22e9'}) }
    end

    context 'kTLVType_Permissions' do
      let(:input) { '0B0112' }
      it { is_expected.to eql({'kTLVType_Permissions' => 18}) }
    end

    context 'kTLVType_FragmentData' do
      let(:input) { '0c10c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({'kTLVType_FragmentData' => 'c8eb453673a905cc5ca6b64ce85e22e9'}) }
    end

    context 'kTLVType_FragmentLast' do
      let(:input) { '0d10c8eb453673a905cc5ca6b64ce85e22e9' }
      it { is_expected.to eql({'kTLVType_FragmentLast' => 'c8eb453673a905cc5ca6b64ce85e22e9'}) }
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
          'kTLVType_Signature' => '61' * 300,
          'kTLVType_Identifier' => 'hello'
        })
      end
    end

    context 'SRP Start Request' do
      let(:input) { '000100060101' }
      it { is_expected.to eql({'kTLVType_Method' => 0, 'kTLVType_State' => 1}) }
    end

    context 'SRP Start Response' do
      let(:input) do
        '0601020210eef0f9f30a085068aa9b129bde03ab3903ff90cd46e05e86acd8fa07d196'\
        '1d37eb594798a31ee1e0e9c76720ab3373bb386a4c869ab7fb84db3012c6ba2edbe2b7'\
        '2a15d491c2c6694ab93a01bd46e3a3165f622484ca411915d2f1415a730f68b1941168'\
        'fbc1c10325ad1ee2fb19f770270f9c74e8f35c0bf204031d665fee200e4ca77d965553'\
        '388f58e50a5663f25bb40ee487fbee230d1231eaeaf9ada4ec9c5a7af6b1a8d3167205'\
        '902961629aec11cadd3cb8c703cb2fa091be7243315677729ecf4b76397dde66a9e930'\
        'e373bee12637b5aeb347130f00fe915bd6b36abc0212fe734ab913339558f9e24a6f14'\
        '608763b544e2e5cfae56d0e2fbf516c92002ddb62099a048df252b39a31c1e105f0381'\
        'd60bbc58357ac18cfaff46da6729c1cead884a47c7068408b4824b9aa43b44aedc04cf'\
        'dfe9cb3997dd8870eb89994cab50ee37eb24d3f6e6b1ba39c2f1b8c967851fe60ac18b'\
        'bd4f8f14825b45aac1ec31a507d77f077cbc02ebb90d7d8e752dfb2493ced237bb1399'\
        '2fee996b4e04a81d68d2e9282bba497f7dcba1bab4f3f2a6'\
      end
      it do
        is_expected.to eql({
          'kTLVType_Salt' => 'eef0f9f30a085068aa9b129bde03ab39',
          'kTLVType_PublicKey' =>
          '90cd46e05e86acd8fa07d1961d37eb594798a31ee1e0e9c76720ab3373bb386a4c869a'\
          'b7fb84db3012c6ba2edbe2b72a15d491c2c6694ab93a01bd46e3a3165f622484ca4119'\
          '15d2f1415a730f68b1941168fbc1c10325ad1ee2fb19f770270f9c74e8f35c0bf20403'\
          '1d665fee200e4ca77d965553388f58e50a5663f25bb40ee487fbee230d1231eaeaf9ad'\
          'a4ec9c5a7af6b1a8d3167205902961629aec11cadd3cb8c703cb2fa091be7243315677'\
          '729ecf4b76397dde66a9e930e373bee12637b5aeb347130f00fe915bd6b36abc0212fe'\
          '734ab913339558f9e24a6f14608763b544e2e5cfae56d0e2fbf516c92002ddb62099a0'\
          '48df252b39a31c1e105fd60bbc58357ac18cfaff46da6729c1cead884a47c7068408b4'\
          '824b9aa43b44aedc04cfdfe9cb3997dd8870eb89994cab50ee37eb24d3f6e6b1ba39c2'\
          'f1b8c967851fe60ac18bbd4f8f14825b45aac1ec31a507d77f077cbc02ebb90d7d8e75'\
          '2dfb2493ced237bb13992fee996b4e04a81d68d2e9282bba497f7dcba1bab4f3f2a6',
          'kTLVType_State' => 2,
        })
      end
    end
  end

  describe '.pack' do
    subject { described_class.pack(input) }

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
      let(:input) { {'kTLVType_Salt' => 'c8eb453673a905cc5ca6b64ce85e22e9'} }
      it { is_expected.to eql(['0210c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'kTLVType_PublicKey' do
      let(:input) { {'kTLVType_PublicKey' => '596ffa328760d19e7b9d'} }
      it { is_expected.to eql(['030a596ffa328760d19e7b9d'].pack('H*')) }
    end

    context 'kTLVType_Proof' do
      let(:input) { {'kTLVType_Proof' => '0fab'} }
      it { is_expected.to eql(['04020fab'].pack('H*')) }
    end

    context 'kTLVType_EncryptedData' do
      let(:input) { {'kTLVType_EncryptedData' => '49625160'} }
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
      let(:input) { {'kTLVType_Certificate' => 'c8eb453673a905cc5ca6b64ce85e22e9'} }
      it { is_expected.to eql(['0910c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'kTLVType_Signature' do
      let(:input) { {'kTLVType_Signature' => 'c8eb453673a905cc5ca6b64ce85e22e9'} }
      it { is_expected.to eql(['0a10c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'kTLVType_Permissions' do
      let(:input) { {'kTLVType_Permissions' => 18} }
      it { is_expected.to eql(['0B0112'].pack('H*')) }
    end

    context 'kTLVType_FragmentData' do
      let(:input) { {'kTLVType_FragmentData' => 'c8eb453673a905cc5ca6b64ce85e22e9'} }
      it { is_expected.to eql(['0c10c8eb453673a905cc5ca6b64ce85e22e9'].pack('H*')) }
    end

    context 'kTLVType_FragmentLast' do
      let(:input) { {'kTLVType_FragmentLast' => 'c8eb453673a905cc5ca6b64ce85e22e9'} }
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
          'kTLVType_Signature' => '61' * 300,
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

    context 'SRP Start Request' do
      let(:input) { {'kTLVType_Method' => 0, 'kTLVType_State' => 1} }
      it { is_expected.to eql(['000100060101'].pack('H*')) }
    end

    context 'SRP Start Response' do
      let(:input) do
        {
          'kTLVType_Salt' => 'eef0f9f30a085068aa9b129bde03ab39',
          'kTLVType_PublicKey' =>
          '90cd46e05e86acd8fa07d1961d37eb594798a31ee1e0e9c76720ab3373bb386a4c869a'\
          'b7fb84db3012c6ba2edbe2b72a15d491c2c6694ab93a01bd46e3a3165f622484ca4119'\
          '15d2f1415a730f68b1941168fbc1c10325ad1ee2fb19f770270f9c74e8f35c0bf20403'\
          '1d665fee200e4ca77d965553388f58e50a5663f25bb40ee487fbee230d1231eaeaf9ad'\
          'a4ec9c5a7af6b1a8d3167205902961629aec11cadd3cb8c703cb2fa091be7243315677'\
          '729ecf4b76397dde66a9e930e373bee12637b5aeb347130f00fe915bd6b36abc0212fe'\
          '734ab913339558f9e24a6f14608763b544e2e5cfae56d0e2fbf516c92002ddb62099a0'\
          '48df252b39a31c1e105fd60bbc58357ac18cfaff46da6729c1cead884a47c7068408b4'\
          '824b9aa43b44aedc04cfdfe9cb3997dd8870eb89994cab50ee37eb24d3f6e6b1ba39c2'\
          'f1b8c967851fe60ac18bbd4f8f14825b45aac1ec31a507d77f077cbc02ebb90d7d8e75'\
          '2dfb2493ced237bb13992fee996b4e04a81d68d2e9282bba497f7dcba1bab4f3f2a6',
          'kTLVType_State' => 2,
        }
      end
      it do
        is_expected.to include(['060102'].pack('H*'))
        is_expected.to include(['0210eef0f9f30a085068aa9b129bde03ab39'].pack('H*'))
        is_expected.to include([
          '03ff90cd46e05e86acd8fa07d1961d37eb594798a31ee1e0e9c76720ab3373bb386a4c',
          '869ab7fb84db3012c6ba2edbe2b72a15d491c2c6694ab93a01bd46e3a3165f622484ca',
          '411915d2f1415a730f68b1941168fbc1c10325ad1ee2fb19f770270f9c74e8f35c0bf2',
          '04031d665fee200e4ca77d965553388f58e50a5663f25bb40ee487fbee230d1231eaea',
          'f9ada4ec9c5a7af6b1a8d3167205902961629aec11cadd3cb8c703cb2fa091be724331',
          '5677729ecf4b76397dde66a9e930e373bee12637b5aeb347130f00fe915bd6b36abc02',
          '12fe734ab913339558f9e24a6f14608763b544e2e5cfae56d0e2fbf516c92002ddb620',
          '99a048df252b39a31c1e105f'
        ].pack('H*'))
        is_expected.to include([
          '0381d60bbc58357ac18cfaff46da6729c1cead884a47c7068408b4824b9aa43b44aedc',
          '04cfdfe9cb3997dd8870eb89994cab50ee37eb24d3f6e6b1ba39c2f1b8c967851fe60a',
          'c18bbd4f8f14825b45aac1ec31a507d77f077cbc02ebb90d7d8e752dfb2493ced237bb',
          '13992fee996b4e04a81d68d2e9282bba497f7dcba1bab4f3f2a6'
        ].pack('H*'))
      end
    end

    context 'Value byte length is a odd (as opposed to even) number' do
      let(:input) { { 'kTLVType_Salt' => '3259528331e701a72df8c77815c8a63' } }
      it 'pads the hexadecimal by prefixing with a 0' do
        is_expected.to eql(['021003259528331e701a72df8c77815c8a63'].pack('H*'))
      end
    end
  end
end

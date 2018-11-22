require 'spec_helper'

RSpec.describe RubyHome::HAP::HTTPEncryption do
  describe '#encrypt' do
    let(:key) { ['273dc7c4e1cfdac3cb78dce01709f93208e6d3236171b58f4a28d8e5e73ee895'].pack('H*') }
    let(:count) { 0 }

    subject do
      described_class.new(key, count: count).encrypt(data)
    end

    context 'short data' do
      let(:data) { 'hello world' }

      it 'encrypts small strings of data' do
        expected_encrypted_data = %w{
          0B00781A E80A8471 9C75E6C6 E4DBBA98 C40CBEDB 5B058D3F 331241AC DF
        }.join.downcase

        expect(subject.unpack1('H*')).to eql(expected_encrypted_data)
      end
    end

    context 'custom count' do
      let(:data) { 'hello world' }
      let(:count) { 2 }

      it 'encrypts using correct nonce' do
        expected_encrypted_data = %w{
          0B00771F 50A03DF3 6B64FE1C A6E0D281 1E83D9F8 0FBD49FA FDA4EB2D B8
        }.join.downcase

        expect(subject.unpack1('H*')).to eql(expected_encrypted_data)
      end
    end

    context 'long data' do
      let(:data) { 'a' * 1025 }

      it 'encrypts small strings of data' do
        expected_encrypted_data_frame_0 = %w{
          0004711E E5078A30 8A7BF5CB E1DF29FA 6C32A826 82554D02 47AFED1D F56D587F
          B72659F9 53113A7F 953649A1 9D51BE10 46E42231 ED733FEB 3D1F749D 3A617B61
          DBDE1410 CA33D0D8 7027D1AA F5AF7F15 D7E2F19C DC774720 A32F6960 EA0D3E58
          F2888210 34BE5697 8C67A9D9 A0ECABAA 49CCF302 14883D11 C8AFACF6 AB8FF5ED
          B40DCA5B BB317385 64B3557D 5ACEA903 FFEA6D6B 18BA7AFB C89E2DAD E5004EAB
          67FDCB02 EB15C81A 4FD8B681 17A16BF4 192662DA 6E61DB0E 5F5EB0F6 61E2A3EF
          533AB1A9 2065A7BC AA00A46B E3F8A09C FF830473 EF9711DF BC88544D E4B3397A
          4A2F14CB C2A5A787 63667762 3C67B6C0 BFDC176F 17D90119 CFCB6B39 0FB5C5F2
          0499E0F0 F0F18984 F17CD044 C7E3EAD4 0AB14910 CFEC1D91 709707FF C4080088
          6346814C 368765E8 C1083385 07A8FE4E 1432CC62 547066CB F184F807 C5A2D06A
          E60A9616 108CA048 466C2045 A7C1CA3F 959BB697 99EA74E9 35734EF3 1DDE44CE
          1D9609A7 FDE3FC9F BDCA08DB C4A7876B DC7C88F5 95EB043E 22D8C7B3 3C99DC47
          3CBBE08D 7B237774 866896BF F8D97B8C 558A64D8 5CBEC60A 4CEA355A CF6089FB
          C6FCAD28 9C9E6074 AAAE7394 FBF36A3C BD5A0AC0 0454DBE0 26E8E3FC A72B7886
          12CE753B 1839C9D2 B2D1363C 3D4B8C1B 1015925B ED1DF602 71B7D31F B83F16AF
          5457A15B 84772AFE 937CCCFF EFEFBB83 BD637485 0A886CA7 ADD4E54B 80DE4BC8
          38DB4BF6 FF5AD432 04AE1A6F 1E47AFA8 DEBE8244 A707F739 A9617654 2B3DD3DD
          79831294 4B853851 CE0543B4 050FDBAE A136E577 F5F4D729 BFC83F6B FA421BBB
          249B4D14 EBB7DB65 E248FD47 13BAC22C 7FEC0714 E3B4EB0E 938DB942 E6A16B4A
          59DA98CD 180EE53E 7AB17552 5C1A23B9 97A096B8 276C4BE5 EDA86654 88D735F9
          3854CCA9 857D26E8 EE8FAF65 7C33B1EF BCD2B5AC AFA2ADD0 162FC567 40AD79A7
          119B1BD5 D93EE5A9 629B923F B55E013A A5285EFB 5EFE917B 55F25574 E607723F
          B650A35C 4EEEBD3B A72DF7F4 D8B826E9 C8CEB00A 619A2233 0EBB28D3 EBCE22E7
          5463B606 5EEEF2B0 3F1E102B D2A8153D A3514A92 515D174E 077A58C8 EF882CF3
          C6CAA08A 4B78454E 2A2951A4 FF5128B4 0AA06C1F 5F9D6D94 56DEBEC3 E3AD00FB
          98375D62 CDC4CE5B B9FD1B15 8F5D0E58 4F8BC131 F1969309 B949469A 11866738
          AE6049BC 2B1D547C FB62C8C3 FD8BF5CD 26CB9CE8 6DFCBD47 A89EDD5C DDE2E0E1
          2DD58D28 9333C23A 609D505B AB47439D AA1811BA 6D8160DD 76B9072D 36B351A7
          01CB7BAF E024DC9A 41952244 2ACCFD0D 1125690E 928C4B16 9CDA549C FC08B9F0
          D75688B5 5DD1E8ED 147D150F 417B3648 0EF6BE52 EE250F2B 476B216F 80B1728B
          5DC26D6C A5AC4737 19DC2CD9 5D0E6BAD 0ED54B3A CB0E79E0 CF4871EA FC1F354E
          BCE740B1 C652CF87 DB7219E9 41A71E50 9F421229 5B12DDFE 612FA627 D3DA755E
          615E4004 64D7B368 EEFE200C 2A95F22C 287E
        }.join.downcase

        expected_encrypted_data_frame_1 = %w{
          0100782F 5C81C735 B347E936 DC6E9172 75BD4B
        }.join.downcase

        expect(subject.unpack1('H*')).to eql(
          expected_encrypted_data_frame_0 + expected_encrypted_data_frame_1
        )
      end
    end
  end
end

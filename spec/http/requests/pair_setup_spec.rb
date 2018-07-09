require 'spec_helper'

RSpec.describe 'POST /pair-setup' do
  context 'SRP Start Response' do
    before do
      path = File.expand_path('../../../fixtures/srp_start_request', __FILE__)
      data = File.read(path)
      post '/pair-setup', data, {'CONTENT_TYPE' => 'application/pairing+tlv8'}
    end

    it 'headers contains application/pairing+tlv8 header' do
      expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
    end

    it 'body contains kTLVType_State' do
      expect(unpacked_body).to include('kTLVType_State' => 2)
    end

    it 'body contains kTLVType_Salt' do
      expect(unpacked_body).to include('kTLVType_Salt' => a_kind_of(String))
    end

    it 'body contains kTLVType_PublicKey' do
      expect(unpacked_body).to include('kTLVType_PublicKey' => a_kind_of(String))
    end

    it 'stores proof in cache' do
      salt = unpacked_body['kTLVType_Salt']
      public_key = unpacked_body['kTLVType_PublicKey']
      expect(read_cache(:srp_session)).to include(
        B: public_key.unpack1('H*'),
        I: 'Pair-Setup',
        b: a_kind_of(String),
        s: salt.unpack1('H*'),
        v: a_kind_of(String)
      )
    end
  end

  context 'SRP Verify Response' do
    let(:b_pub) do
      %w{
        3818FEE2 97FB0201 729E04C3 644A6C5D 5099F556 7F1791F7 92666C3C 70A3C1B3
        CEADEBE5 7130EF6C EFEFCB12 96EF7F5D 50FBC4EC C340DB99 2423EC14 1305043E
        BDE8F105 D08C5CD3 BE9B6063 8EDDA3AD 1B90BC55 779B647A B72769FF 966E3381
        D8E57670 BA93B32F CC5D2FC8 D226D787 7E41C9DC 5C73961C 795C9712 E41C0614
        435A018C 457E477D 15A21120 6120B92D 8192C103 75C2B2B6 0F5DF6CC A04563CB
        2A67FD52 ECC197C8 EE077CEC 56DC345E 0BD7DCB9 D0F94C65 E4B1C6CC B7501663
        FA1AD2F1 42BCBD39 003BF654 013A2728 08D41C4F B4FBBF28 AAE44122 F1A1BA61
        6723350E 829D6EE8 FA41C2E3 9D9769A8 D8210FB0 FB9DA88E 55C2F08A 6A3D7CC1
        A57E225C B0FA6EB9 3E6C2F1D 8262C9A9 07B7CBCE C55F8945 867F41FA E2474BBB
        76A53C06 1E49E132 328766DA 69F8D695 574F6689 D6E65CE5 BCE1B76F C5EC7F66
        EAB9F0BE A374C5C4 971638EA F35140BE AD4BCBB8 823D46FC F9E20B09 9EE11B9A
        82FE3234 B55E154A E295A94D 0DAC1356 D03FD0A1 BA51BD2E E529E5A6 EAE2F05B
      }.join.downcase
    end
    let(:b) do
      %w{
        1C53D956 01885908 34C60F8C E85C56B3 2812EFB6 9DB43835 CB1A7594 47557AFE
      }.join.downcase
    end
    let(:salt) do
      %w{
        2B08BA0B E7B88614 B9EDFCBD 507BD9F2
      }.join.downcase
    end
    let(:verifier) do
      %w{
        16C4FDF3 6987A85B 50255FEE C7CCEBE6 E0C88B43 F210EBD6 03D065E1 E10B2C77
        A608AD73 C4DEDF65 9C6EF469 B6E8C45D 13D8242B 6E4D8270 EECB8400 F41A94DC
        3FE621D6 C56A14A3 8234E403 AC243EEE 51FE770D 9F36B30B BA042038 F20E7800
        870D9553 E573B683 509CFD6A 34D20A05 869BD807 5F198766 0BF192ED 2DC5CCC9
        0DD4199B 67AA4D33 1099C487 B5CD3E03 B797F470 222AD96E FD1AE772 89592B53
        22C8A274 8AD66059 0A5E0EA3 C98C665F CA391133 05B797BD C5FED3E2 69CD9F90
        0CC43633 7E32C252 2558EA21 F7BA5BB9 1E1F3DD6 51F2CFBF 4C8D1949 6C8104D0
        0A4E7C66 68DA50B7 B7F87A7E 638DE33D 8A790726 87EE60FB 9A6E1E39 D5D773FA
        808CF766 82FFE187 1016E0C1 A561836B 9C0E842B 11392453 1F58E61F 4BA5B17C
        403115E0 22F9255C 3E651CB5 283B4E6B 5084D3F7 551BCD0A 338A86DE D2CFCFD3
        4DAA077F 7A38B8E3 50B22D39 23DE9661 E30E4C3F 3515EF1C BA511BE6 9AA5548F
        D15793F8 02099A46 C8D8FC4F 4D0B1E59 97311C8F DE59CC2E 22A5BF34 8A47D636
      }.join.downcase
    end
    let(:data) do
      File.read(File.expand_path('../../../fixtures/srp_verify_request', __FILE__))
    end

    before do
      set_cache(:srp_session, {
        B: b_pub,
        b: b,
        I: 'Pair-Setup',
        s: salt,
        v: verifier
      })
      post '/pair-setup', data, { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
    end

    context 'valid verify response request' do
      it 'headers contains application/pairing+tlv8 header' do
        expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
      end

      it 'body contains kTLVType_State' do
        expect(unpacked_body).to include('kTLVType_State' => 4)
      end

      it 'body contains kTLVType_Proof' do
        public_key = unpacked_body['kTLVType_Proof'].unpack1('H*')
        expected_proof = %w{
          986161DE 6D267DFE D08402CE 7A9EA5A0 27C09F04 2D70AD65 F374ADC7 D0F0F152
          033B4B94 0583C317 0CD4C326 4BB093C0 B518F8C9 710B6F68 A56E5B03 D0686EDA
        }.join.downcase
        expect(public_key).to eql(expected_proof)
      end

      it 'stores session_key' do
        expected_session_key = %w{
          2B5F1FA4 046B2E63 2A06F1D9 612B031F 6D0B9676 B602DD36 BFCFEA0F 85D8567E
          DDEBF2EF B5C24227 DF05D9F8 BECC3F32 518CEAAD BA5F689F 50252F6B E5D77EA6
        }.join.downcase
        expect(read_cache(:session_key)).to eql(expected_session_key)
      end

      it 'destroy srp_session' do
        expect(read_cache(:srp_session)).to be_nil
      end
    end

    context 'invalid verify response request' do
      context 'no kTLVType_PublicKey supplied' do
        let(:data) { RubyHome::HAP::TLV.encode('kTLVType_State' => 3) }

        it 'responds with error' do
          expect(unpacked_body).to include('kTLVType_State' => 4, 'kTLVType_Error' => 2)
        end

        it 'clears the cache' do
          expect(read_cache).to be_empty
        end
      end

      context 'SRP_verify verification fails' do
        let(:data) do
          RubyHome::HAP::TLV.encode(
            'kTLVType_State' => 3,
            'kTLVType_PublicKey' => 'foo',
            'kTLVType_Proof' => 'foo'
          )
        end

        it 'responds with error' do
          expect(unpacked_body).to include('kTLVType_State' => 4, 'kTLVType_Error' => 2)
        end

        it 'clears the cache' do
          expect(read_cache).to be_empty
        end
      end
    end
  end

  context 'Exchange Response' do
    let(:session_key) do
      %w{
        7D9E8A37 2C395CC5 F4CF2AB4 D960E6D1 76FBCFC9 587DE6B6 9E3114B6 D39C6D83
        7CA464CE F3A1D51E CC1674E2 6D57783D D72B5438 882B93F6 EDCADF65 FC15288F
      }.join.downcase
    end

    before do
      set_cache(:session_key, session_key)
      path = File.expand_path('../../../fixtures/exchange_request', __FILE__)
      data = File.read(path)
      post '/pair-setup', data, { 'CONTENT_TYPE' => 'application/pairing+tlv8' }
    end

    it 'headers contains application/pairing+tlv8 header' do
      expect(last_response.headers).to include('Content-Type' => 'application/pairing+tlv8')
    end

    it 'body contains kTLVType_State' do
      expect(unpacked_body).to include('kTLVType_State' => 6)
    end

    it 'body contains kTLVType_EncryptedData' do
      encrypted_data = unpacked_body['kTLVType_EncryptedData'].unpack1('H*')
      expected_encrypted_data = %w{
        51445260 6E942707 25D0A470 8708B97B C9A495FB A0900796 A2BCF06F 8388829B
        6F6B7C09 BEE33B8F DEAD373D 83EBB92F 395B0C9B C16A8AA1 8F13EA58 F89ADF8A
        87BB4F07 8E960854 09D0BD50 02947917 FE9A0486 88E42885 1AAB213E 52B69A97
        5C3EC2CD 46E43A7A 94BCDFC3 7A4BEEF1 60612F16 C0E82753 C0D0099A 93D2F4B0
        1CF924B0 97F08C
      }.join.downcase
      expect(encrypted_data).to eql(expected_encrypted_data)
    end

    it 'creates pairing record' do
      expected_identifier = '349CBC7D-01B9-4DC4-AD98-FB9029BB77F2'
      expected_public_key = '62398c58854a0718b19a64445f5f63761472802dd15ddf19cc74bee253dde525'

      expect(RubyHome::AccessoryInfo.paired_clients).to match(
        a_hash_including(
          admin: true,
          identifier: expected_identifier,
          public_key: expected_public_key
        )
      )
    end
  end
end

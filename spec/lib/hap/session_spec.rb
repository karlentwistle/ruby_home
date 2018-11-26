require 'spec_helper'

RSpec.describe RubyHome::HAP::Session do
  describe '#decrypt' do
    let(:io) { StringIO.new }
    subject(:session) { described_class.new(io, encrypter_class: CaesarCipher) }

    describe '#encryption_time?' do
      it 'returns true if accessory_to_controller_key is present and received encrypted request' do
        session.controller_to_accessory_count = 1
        session.accessory_to_controller_key = 'foo'

        expect(session.encryption_time?).to be true
      end

      it 'returns false by default' do
        expect(session.encryption_time?).to be false
      end
    end

    describe '#received_encrypted_request?' do
      it 'returns true if controller_to_accessory_count is greater than 0' do
        session.controller_to_accessory_count = 1
        expect(session.received_encrypted_request?).to be true
      end

      it 'returns false by default' do
        expect(session.received_encrypted_request?).to be false
      end
    end

    describe '#decryption_time?' do
      it 'returns true if controller_to_accessory_key is present' do
        session.controller_to_accessory_key = 'foo'
        expect(session.decryption_time?).to be true
      end

      it 'returns false by default' do
        expect(session.decryption_time?).to be false
      end
    end

    describe '#sufficient_privileges?' do
      it 'returns true if controller_to_accessory_key and accessory_to_controller_key is present' do
        session.controller_to_accessory_key = 'foo'
        session.accessory_to_controller_key = 'bar'
        expect(session.sufficient_privileges?).to be true
      end

      it 'returns false by default' do
        expect(session.sufficient_privileges?).to be false
      end
    end

    describe '#active?' do
      it 'returns true if socket is still active' do
        expect(session.active?).to be true
      end

      it 'returns false if socket is no longer active' do
        io.close
        expect(session.active?).to be false
      end
    end

    describe 'write' do
      it 'by default it writes inputted data' do
        session.write("hello world")

        io.rewind
        expect(io.read).to eql("hello world")
      end

      it 'writes data encrypted if encryption_time?' do
        session.controller_to_accessory_count = 1
        session.accessory_to_controller_key = accessory_to_controller_key

        session.write("hello world")

        io.rewind
        expect(io.read).to eql("ifmmp xpsme \n")
      end

      it 'keeps track of count for each write request if encryption_time?' do
        session.controller_to_accessory_count = 1
        session.accessory_to_controller_key = accessory_to_controller_key

        session.write("hello world")
        session.write("hello world")

        io.rewind
        expect(io.readline).to eql("ifmmp xpsme \n")
        expect(io.readline).to eql("jgnnq yqtnf \n")
      end
    end

    class CaesarCipher
      def initialize(key, count: 0)
        @key = key
        @count = count
      end

      def encrypt(data)
        @count += 1
        caesar_cipher(data)
      end

      private

        def caesar_cipher(string)
          shift      = count
          alphabet   = Array('a'..'z')
          encrypter  = Hash[alphabet.zip(alphabet.rotate(shift))]
          string.chars.map { |c| encrypter.fetch(c, " ") }.join + " \n"
        end

        attr_reader :count
    end

    def accessory_to_controller_key
      ['273dc7c4e1cfdac3cb78dce01709f93208e6d3236171b58f4a28d8e5e73ee895'].pack('H*')
    end
  end
end

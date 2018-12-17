require 'spec_helper'

RSpec.describe RubyHome::HAP::Session do
  describe '#decrypt' do
    let(:io) { StringIO.new }
    subject(:session) do
      described_class.new(
        io,
        decrypter_class: CaesarCipher,
        encrypter_class: CaesarCipher
      )
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
        expect(session).to be_active
      end

      it 'returns false if socket is no longer active' do
        io.close
        expect(session).not_to be_active
      end
    end

    describe '#parse' do
      it 'by default it returns socket' do
        expect(session.parse).to eql(io)
      end

      it 'decrypts data using decrypter if decryption_time' do
        session.controller_to_accessory_key = 'foo'
        io.write('ifmmp xpsme')
        io.rewind

        expect(session.parse.readline).to eql("hello world \n")
      end
    end

    describe '#write' do
      it 'by default it writes inputted data' do
        session.write('hello world')

        io.rewind
        expect(io.read).to eql('hello world')
      end

      it 'writes data encrypted if encryption_time' do
        session.received_encrypted_request!
        session.accessory_to_controller_key = 'foo'

        session.write('hello world')

        io.rewind
        expect(io.read).to eql("ifmmp xpsme \n")
      end

      it 'keeps track of count for each write request if encryption_time' do
        session.received_encrypted_request!
        session.accessory_to_controller_key = 'foo'

        session.write('hello world')
        session.write('hello world')

        io.rewind
        expect(io.readline).to eql("ifmmp xpsme \n")
        expect(io.readline).to eql("jgnnq yqtnf \n")
      end
    end

    describe '#<<' do
      it 'supports writing data with << for backwards compatibility' do
        expect(session.method(:<<)).to eql(session.method(:write))
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

      def decrypt(data)
        @count -= 1
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
  end
end

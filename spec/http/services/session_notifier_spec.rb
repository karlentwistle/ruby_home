require 'spec_helper'

RSpec.describe RubyHome::HTTP::SessionNotifier do
  let(:socket) { StringIO.new }
  let(:session) { RubyHome::HAP::Session.new(socket) }
  let(:service) { RubyHome::ServiceFactory.create(:outlet) }
  let(:characteristic) { service.characteristic(:outlet_in_use) }
  subject { RubyHome::HTTP::SessionNotifier.new(session, characteristic) }

  describe '#after_update' do
    context 'socket still active' do
      it 'sends ev_response to socket' do
        set_session_key
        subject.after_update(characteristic)

        socket.rewind
        actual_response = socket.read.unpack1('H*')
        expected_response = %w{
          81005529 C128BF7E DA34A48A B28E78BB 4218C44D A05B4217 43A0F851 C075497B
          EC6759E8 421C327D 952341AF 921FB710 57AE2923 E37C5380 1F117B88 3E6E6E2D
          F6DA1B16 DF3A8B99 2475BDC1 99C46556 D5EBF18F DC755224 B0277B75 E20F2C1B
          A9B29853 34B653D4 D737E49A A8E4AEE9 129EBE41 03883005 CCECF7F1 AB82E7E9
          A831D60C 3B5C2A22 5367C226 D1D00233 7A37B9
        }.join.downcase
        expect(actual_response).to eql(expected_response)
      end
    end

    context 'socket no longer active' do
      it 'unsubscribes socket notifier from characteristic' do
        socket.close
        subject.after_update(characteristic)

        expect(characteristic.local_registrations).not_to include(subject)
      end
    end

    it 'receives event from characteristic if value changes' do
      set_session_key
      characteristic.subscribe(subject)

      characteristic.value = false

      socket.rewind
      expect(socket.read).not_to be_empty
    end
  end

  private

    def set_session_key
      session.accessory_to_controller_key = session_key
    end

    def session_key
      ['273dc7c4e1cfdac3cb78dce01709f93208e6d3236171b58f4a28d8e5e73ee895'].pack('H*')
    end
end

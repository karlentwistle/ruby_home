require "spec_helper"

RSpec.describe RubyHome::HTTP::SessionNotifier do
  let(:socket) { StringIO.new }
  let(:session) { RubyHome::HAP::Session.new(socket) }
  let(:service) { RubyHome::ServiceFactory.create(:outlet) }
  let(:characteristic) { service.outlet_in_use }
  subject { RubyHome::HTTP::SessionNotifier.new(session, characteristic) }

  describe "#after_update" do
    context "socket still active" do
      it "sends ev_response to socket" do
        set_session_key
        subject.after_update(characteristic)

        socket.rewind
        actual_response = socket.read.unpack1("H*")

        expected_response = %w[
          4556454E 542F312E 30203230 30204F4B 0D0A436F 6E74656E 742D5479 70653A20
          6170706C 69636174 696F6E2F 6861702B 6A736F6E 0D0A436F 6E74656E 742D4C65
          6E677468 3A203533 0D0A0D0A 7B226368 61726163 74657269 73746963 73223A5B
          7B226169 64223A31 2C226969 64223A33 2C227661 6C756522 3A66616C 73657D5D
          7D
        ].join.downcase
        expect(actual_response).to eql(expected_response)
      end
    end

    context "socket no longer active" do
      it "unsubscribes socket notifier from characteristic" do
        socket.close
        subject.after_update(characteristic)

        expect(characteristic.local_registrations).not_to include(subject)
      end
    end

    it "receives event from characteristic if value changes" do
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
    ["273dc7c4e1cfdac3cb78dce01709f93208e6d3236171b58f4a28d8e5e73ee895"].pack("H*")
  end
end

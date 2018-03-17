require 'spec_helper'

RSpec.describe Rubyhome::SpeakerFactory do
  describe '.new' do
    it 'allows customization of mute' do
      speaker_factory = Rubyhome::SpeakerFactory.new(mute: false)
      expect(speaker_factory.mute).to eq(
        Rubyhome::Characteristic::Mute.new(value: false, service: speaker_factory.service)
      )
    end
  end

  describe '#service' do
    it 'automatically generates a service' do
      speaker = Rubyhome::SpeakerFactory.new
      expect(speaker.service).to be_a(Rubyhome::Service::Speaker)
    end
  end

  describe '#accessory_information' do
    it 'automatically generates accessory information' do
      speaker = Rubyhome::SpeakerFactory.new
      expect(speaker.accessory_information).to be_a(Rubyhome::AccessoryInformationFactory)
    end
  end
end

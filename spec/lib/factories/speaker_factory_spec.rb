require 'spec_helper'

RSpec.describe Rubyhome::SpeakerFactory do
  describe '.new' do
    it 'requires name' do
      expect(Rubyhome::SpeakerFactory.new).to be_truthy
    end
  end
end

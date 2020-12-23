RSpec.describe RubyHome::SetupID do

  describe 'Setup ID generator' do
    it 'outputs lenght of 4' do
      expect(RubyHome::SetupID.generate.length).to eql(4)
    end
  end

end

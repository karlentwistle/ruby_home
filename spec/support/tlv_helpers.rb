module TLVHelpers
  def unpacked_body
    RubyHome::HAP::TLV.read(last_response.body)
  end
end

RSpec.configure do |config|
  config.include TLVHelpers
end

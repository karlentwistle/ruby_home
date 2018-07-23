module TLVHelpers
  def unpacked_body
    RubyHome::HAP::TLV.read(last_response.body)
  end

  def tlv_encode(input)
    RubyHome::HAP::TLV.encode(input)
  end
end

RSpec.configure do |config|
  config.include TLVHelpers
end

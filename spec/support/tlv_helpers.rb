module TLVHelpers
  def unpacked_body
    RubyHome::TLV.decode(last_response.body)
  end

  def tlv_encode(input)
    RubyHome::TLV.encode(input)
  end
end

RSpec.configure do |config|
  config.include TLVHelpers
end

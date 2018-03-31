module TLVHelpers
  def unpacked_body
    RubyHome::TLV.unpack(last_response.body)
  end
end

RSpec.configure do |config|
  config.include TLVHelpers
end

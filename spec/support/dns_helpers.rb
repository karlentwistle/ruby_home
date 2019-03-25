module DNSHelpers
  def dns_text_record(key)
    service = DNSSD::Service.browse '_hap._tcp'
    reply = service.each.find { |r| r.name == "RubyHome" }
    service.stop
    resolver = DNSSD::Service.resolve reply.name, reply.type, reply.domain
    text = resolver.each.find(&:text_record).text_record
    text[key]
  end
end

RSpec.configure do |config|
  config.include DNSHelpers
end

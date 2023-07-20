require "spec_helper"

RSpec.describe "GET /accessories" do
  context "Request denied due to insufficient privileges" do
    before do
      get "/accessories", nil, {"CONTENT_TYPE" => "application/hap+json"}
    end

    it "headers contains application/hap+json" do
      expect(last_response.headers).to include("Content-Type" => "application/hap+json")
    end

    it "response status 401" do
      expect(last_response.status).to eql(401)
    end

    it "response body includes status" do
      expect(last_response.body).to eql('{"status":-70401}')
    end
  end

  context "Sufficient privileges and no error occurs" do
    before do
      session.controller_to_accessory_key = ["a" * 64].pack("H*")
      session.accessory_to_controller_key = ["b" * 64].pack("H*")
    end

    it "headers contains application/hap+json" do
      get "/accessories", nil, {"CONTENT_TYPE" => "application/hap+json"}

      expect(last_response.headers).to include("Content-Type" => "application/hap+json")
    end

    it "response status 200" do
      get "/accessories", nil, {"CONTENT_TYPE" => "application/hap+json"}

      expect(last_response.status).to eql(200)
    end

    it "responds with accessories" do
      create_fan_accessory

      get "/accessories", nil, {"CONTENT_TYPE" => "application/hap+json"}

      expect(JSON.parse(last_response.body)).to eql(JSON.parse(fan_fixture_data))
    end

    it "includes linked accessories services" do
      create_television_accessory

      get "/accessories", nil, {"CONTENT_TYPE" => "application/hap+json"}

      linked_value = JSON.parse(last_response.body)["accessories"][0]["services"][0]["linked"]
      expect(linked_value).to eql([14])
    end

    it "includes accessories services valid values" do
      create_television_accessory

      get "/accessories", nil, {"CONTENT_TYPE" => "application/hap+json"}

      valid_values = JSON.parse(last_response.body)["accessories"][0]["services"][0]["characteristics"][0]["valid-values"]
      expect(valid_values).to eql([0, 1])
    end

    it "includes accessories services characteristics numeric properties" do
      heater_cooler = RubyHome::ServiceFactory.create(:heater_cooler, cooling_threshold_temperature: 10)
      cooling_threshold_temperature = heater_cooler.cooling_threshold_temperature

      get "/accessories", nil, {"CONTENT_TYPE" => "application/hap+json"}

      characteristics = JSON.parse(last_response.body).dig("accessories", 0, "services", 0, "characteristics")
      characteristic = characteristics.find { |c| c["iid"] == cooling_threshold_temperature.instance_id }
      expect(characteristic).to include(
        "minValue" => 10,
        "maxValue" => 30,
        "minStep" => 0.1
      )
    end
  end

  def create_fan_accessory
    RubyHome::ServiceFactory.create(:accessory_information)
    RubyHome::ServiceFactory.create(:fan, name: "Fan")
  end

  def create_television_accessory
    accessory = RubyHome::Accessory.new
    television = RubyHome::ServiceFactory.create(
      :television,
      accessory: accessory,
      primary: true,
      configured_name: "Television",
      active: 1,
      active_identifier: 1,
      sleep_discovery_mode: 1,
      remote_key: nil
    )
    speaker = RubyHome::ServiceFactory.create(
      :television_speaker,
      accessory: accessory,
      mute: 0
    )
    television.linked = [speaker]
  end

  def fan_fixture_data
    path = File.expand_path("../../../fixtures/accessories_json/fan.json", __FILE__)
    File.read(path)
  end
end

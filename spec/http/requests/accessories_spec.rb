require "spec_helper"

RSpec.describe "POST /pair-verify" do
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
      expect(last_response.body).to eql("{\"status\":-70401}")
    end
  end
end

require 'rails_helper'

RSpec.describe "Mans", type: :request do
  describe "GET /mans" do
    it "works! (now write some real specs)" do
      get mans_index_path
      expect(response).to have_http_status(200)
    end
  end
end

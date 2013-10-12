require 'spec_helper'

describe StaticController do
  StaticController::PAGES.each do |page|
    describe "GET '#{page}'" do
      it "returns http success" do
        get(page)
        response.should be_success
      end
    end
  end
end

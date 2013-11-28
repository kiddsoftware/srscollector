# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  subject(:user) { FactoryGirl.create(:user) }

  it { should have_many(:cards) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }
  it { should_not validate_presence_of(:api_key) }
  it { should_not validate_presence_of(:auth_token) }

  describe "#ensure_api_key!" do
    it "generates an api_key if none is present and saves the user" do
      user.api_key.should be_nil
      user.ensure_api_key!
      user.should_not be_changed # It should already be saved.
      key = user.api_key
      key.should_not be_nil
      user.ensure_api_key!
      user.api_key.should == key
    end
  end

  describe "#ensure_auth_token!" do
    it "generates an auth_token if none is present" do
      # Shares code with above, so don't worry about the details.
      user.auth_token.should be_nil
      user.ensure_auth_token!
      user.auth_token.should_not be_nil
    end
  end

  describe "#clear_auth_token!" do
    it "resets the auth_token" do
      user.ensure_auth_token!
      user.clear_auth_token!
      user.auth_token.should be_nil
    end
  end

  describe "#anki_deck_for" do
    let(:en) { FactoryGirl.create(:english) }
    let(:fr) { FactoryGirl.create(:french) }

    it "puts cards in correct detect depending on language" do
      card_fr = FactoryGirl.build(:card, language: fr)
      user.anki_deck_for(card_fr).should == "Français::Écrit"

      card_en = FactoryGirl.build(:card, language: en)
      user.anki_deck_for(card_en).should == "English::Reading"

      card_unk = FactoryGirl.build(:card, language: nil)
      user.anki_deck_for(card_unk).should be_nil
    end
  end
end

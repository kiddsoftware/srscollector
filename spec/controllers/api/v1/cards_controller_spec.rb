# -*- coding: utf-8 -*-
require 'spec_helper'

describe API::V1::CardsController do
  let!(:user) do
    FactoryGirl.create(:user, password: "pw", password_confirmation: "pw")
  end
  let!(:card1) do
    FactoryGirl.create(:card, user: user, front: "Card 1", state: 'reviewed')
  end
  let!(:card2) do
    FactoryGirl.create(:card, user: user, front: "Card 2", state: 'new')
  end
  let!(:not_my_card) do
    FactoryGirl.create(:card)
  end

  before { sign_in(user) }

  describe "GET 'index'" do
    it "fails if not logged in" do
      sign_out(user)
      get 'index', format: 'json'
      response.should_not be_success
      response.response_code.should == 401
    end

    it "returns all cards" do
      get 'index', format: 'json'
      response.should be_success
      json['cards'].length.should == 2
      json['cards'].map {|j| j['id'] }.should include(card1.id, card2.id)
    end

    it "can be queried for all cards in a specific state" do
      get 'index', format: 'json', state: 'reviewed'
      response.should be_success
      json['cards'].length.should == 1
    end

    it "can return cards in CSV format" do
      get 'index', format: 'csv', state: 'reviewed'
      response.should be_success
      response.body.should match(/Card 1/)
      response.body.should_not match(/Card 2/)
    end

    it "can return card media in ZIP format" do
      get 'index', format: 'zip', state: 'reviewed'
      response.should be_success
    end

    it "can return the next card to be reviewed, or none" do
      get 'index', format: 'json', state: 'new', sort: 'age', limit: 1
      response.should be_success
      json['cards'].length.should == 1
      card = json['cards'][0]
      card['front'].should == 'Card 2'

      card['state'] = 'reviewed'
      put 'update', format: 'json', id: card['id'], card: card
      response.should be_success

      @json = nil # HACK: Clear JSON cache. Fix this cache to be smarter.
      get 'index', format: 'json', state: 'new', sort: 'age', limit: 1
      json['cards'].length.should == 0
    end

    it "can be called using an auth_token" do
      sign_out(user)
      user.ensure_auth_token!
      cookies[:auth_token] = user.auth_token
      get 'index', format: 'json'
      response.should be_success
      session[:user_id].should == user.id
    end

    it "can return cards in export format with media links" do
      # Get our other cards out of the way
      card1.destroy
      card2.destroy

      # Create a new card with an associated media file.
      image_url = stub_image_url
      attrs = {
        user: user,
        state: "reviewed",
        front: "front",
        back: "<img src=#{image_url.to_json}>",
        source: "e",
        source_url: "http://www.example.com/"
      }
      card = FactoryGirl.create(:card, attrs)
      card.save!
      card.media_files.length.should == 1
      mf = card.media_files[0]

      # Export our cards.
      get 'index', format: 'json', state: 'reviewed', serializer: 'export'
      response.should be_success

      json['meta']['anki_addon']['min_version'].should == 1

      json['cards'].length.should == 1
      card_json = json['cards'][0]
      card_json['back'].should ==
        "<img src=#{card.media_files[0].export_filename.to_json}>"
      card_json['source_html'].should ==
        '<a href="http://www.example.com/">e</a>'
      card_json['anki_deck'].should == "Français::Écrit"
      card_json['media_files'].length.should == 1
      mf_json = card_json['media_files'][0]
      mf_json['url'].should == mf.url
      mf_json['export_filename'].should == mf.export_filename
      mf_json['download_url'].should == mf.file.url

      # Make sure we get the models, too.
      card_json["card_model_id"].should_not be_nil
      json['card_models'][0]['id'].should == card_json["card_model_id"]
      json['card_models'][0]['short_name'].should == "basic"
    end
  end

  describe "GET 'stats'" do
    it "returns some interesting statistics about the available cards" do
      get 'stats', format: 'json'
      response.should be_success
      json['stats']['state']['new'].should == 1
      json['stats']['state']['reviewed'].should == 1
      json['stats']['state']['exported'].should == 0
    end
  end

  describe "GET 'show'" do
    it "returns a single card" do
      get 'show', format: 'json', id: card1.to_param
      response.should be_success
      json['card']['id'].should == card1.id
    end
  end

  describe "POST 'create'" do
    it "creates a card" do
      attrs = FactoryGirl.attributes_for(:card, source: "Via POST")
      post 'create', format: 'json', card: attrs
      response.should be_success
      Card.where(source: "Via POST").length.should == 1
    end

    it "creates multiple cards if passed multiple records" do
      attrs1 = FactoryGirl.attributes_for(:card, front: "Via POST 1")
      attrs2 = FactoryGirl.attributes_for(:card, front: "Via POST 2")
      post 'create', format: 'json', cards: [attrs1, attrs2]
      response.should be_success
      Card.where(front: "Via POST 1").length.should == 1
      Card.where(front: "Via POST 2").length.should == 1
    end
  end

  describe "POST 'mark_reviewed_as_exported'" do
    it "marks all reviewed cards as exported by default" do
      post 'mark_reviewed_as_exported', format: 'json'
      response.should be_success
      card1.reload
      card1.state.should == 'exported'
    end

    it "only marks specified cards as exported if passed a list" do
      card3 = FactoryGirl.create(:card, user: user, front: "Card 3",
                                 state: 'reviewed')
      post 'mark_reviewed_as_exported', format: 'json', id: [card3.to_param]
      card1.reload; card1.state.should == 'reviewed'
      card3.reload; card3.state.should == 'exported'
    end
  end

  describe "PUT 'update'" do
    it "updates a card" do
      put 'update', format: 'json', id: card1.id, card: { back: "Via PUT" }
      response.should be_success
      Card.where(back: "Via PUT").length.should == 1
    end
  end

  describe "DELETE 'destroy'" do
    it "destroys a card" do
      delete 'destroy', format: 'json', id: card1.id
      response.should be_success
      Card.where(id: card1).should be_empty
    end
  end
end

require 'spec_helper'

describe API::V1::CardsController do
  let!(:card1) { FactoryGirl.create(:card, front: "Card 1", state: 'reviewed') }
  let!(:card2) { FactoryGirl.create(:card, front: "Card 2", state: 'new') }

  describe "GET 'index'" do
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
    it "marks all reviewed cards as exported" do
      post 'mark_reviewed_as_exported', format: 'json'
      response.should be_success
      card1.reload
      card1.state.should == 'exported'
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

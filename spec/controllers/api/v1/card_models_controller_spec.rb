require 'spec_helper'

describe API::V1::CardModelsController do
  let!(:card_model) { default_card_model_for_spec }

  describe "GET 'index'" do
    it "returns all the card models" do
      get 'index', format: 'json'
      response.should be_success
      json['card_models'].length.should == 1

      # Test serialization carefully, because the Anki plugin will depend on
      # this serialization behavior and it we can't auto-update it.
      card_model_json = json['card_models'][0]
      card_model_json['id'].should == card_model.id
      card_model_json['name'].should == card_model.name
      card_model_json['short_name'].should == card_model.short_name
      card_model_json['anki_css'].should == card_model.anki_css
      card_model_json['cloze'].should == false

      card_model.card_model_templates.length.should == 1
      card_model.card_model_templates.each_with_index do |template, index|
        template_json = card_model_json['card_model_templates'][index]
        template_json['name'].should == template.name
        template_json['anki_front_template'].should ==
          template.anki_front_template
        template_json['anki_back_template'].should ==
          template.anki_back_template
      end

      card_model.card_model_fields.length.should == 3
      card_model.card_model_fields.each_with_index do |field, index|
        field_json = card_model_json['card_model_fields'][index]
        field_json['id'].should == field.id
        field_json['name'].should == field.name
        field_json['card_attr'].should == field.card_attr
      end
    end
  end
  
  describe "GET 'show'" do
    it "returns a specific card models" do
      get 'show', format: 'json', id: card_model.to_param
      response.should be_success
      json['card_model']['short_name'].should == card_model.short_name
      # Assume other fields are as above.
    end
  end
end

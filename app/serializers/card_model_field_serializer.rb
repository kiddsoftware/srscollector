class CardModelFieldSerializer < ActiveModel::Serializer
  attributes :id, :name, :card_attr

  # Don't serialize this until we must.  Let's keep our JSON as small as
  # possible.
  #has_one :card_model, embed: :id
end

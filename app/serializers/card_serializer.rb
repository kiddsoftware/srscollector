class CardSerializer < ActiveModel::Serializer
  attributes(:id, :state, :front, :back, :source, :source_url, :created_at,
             :updated_at)
end

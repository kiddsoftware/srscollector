class UserSerializer < ActiveModel::Serializer
  attributes(:id, :email, :supporter)
end

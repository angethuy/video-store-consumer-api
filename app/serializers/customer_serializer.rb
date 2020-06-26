class CustomerSerializer < ActiveModel::Serializer
  attribute :id, if: -> { object.id != nil }

  attributes :name, :registered_at, :address, :city, :state, :postal_code, :phone, :account_credit, :movies_checked_out_count
  
end
class MovieSerializer < ActiveModel::Serializer
  attribute :id, if: -> { object.id != nil }
  attribute :available_inventory, if: -> { object.available_inventory && object.available_inventory != nil }

  attributes :title, :overview, :release_date, :image_url, :external_id
  
end

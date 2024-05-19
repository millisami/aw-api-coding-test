module V1
  class ContentSerializer
    include JSONAPI::Serializer
    set_key_transform :camel_lower
    
    attributes :title, :body, :created_at, :updated_at
  end
end

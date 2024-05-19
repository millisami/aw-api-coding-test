module V1
  class UserSerializer
    include JSONAPI::Serializer
    set_key_transform :camel_lower
    
    attributes :first_name, :last_name, :email, :country
  end
end

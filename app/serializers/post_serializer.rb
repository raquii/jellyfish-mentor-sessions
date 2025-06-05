class PostSerializer
  include JSONAPI::Serializer
  attributes :title, :body
end

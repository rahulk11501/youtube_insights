# app/graphql/types/video_lookup_type.rb
module Types
  class VideoLookupType < Types::BaseObject
    field :id, ID, null: false
    field :video_id, String, null: false
    field :title, String, null: true
    field :description, String, null: true
    field :thumbnail_url, String, null: true
    field :published_at, GraphQL::Types::ISO8601DateTime, null: true
    field :channel_id, String, null: true
    field :channel_title, String, null: true
    field :view_count, GraphQL::Types::BigInt, null: true
    field :like_count, GraphQL::Types::BigInt, null: true
    field :comment_count, GraphQL::Types::BigInt, null: true
    field :last_fetched_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end

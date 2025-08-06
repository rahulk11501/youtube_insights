# frozen_string_literal: true

module Types
  class ChannelLookupType < Types::BaseObject
    field :id, ID, null: false
    field :input, String
    field :channel_id, String
    field :title, String
    field :description, String
    field :thumbnail_url, String
    field :subscriber_count, Integer
    field :video_count, Integer
    field :view_count, Integer
    field :last_fetched_at, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

module Queries
  module ChannelQueries
    extend ActiveSupport::Concern

    included do
      field :channel_lookup, Types::ChannelLookupType, null: true do
        description "Find a channel by ID"
        argument :id, GraphQL::Types::ID, required: true
      end

      field :all_channel_lookups, [Types::ChannelLookupType], null: false do
        description "Fetch all channel lookups stored in the database"
      end

      field :search_channels, [Types::ChannelLookupType], null: false do
        description "Search for YouTube channels by keyword or name"
        argument :query, String, required: true
      end
    end

    def channel_lookup(id:)
      ChannelLookup.find_by(id: id)
    end

    def all_channel_lookups
      ChannelLookup.all
    end

    def search_channels(query:)
      Youtube::ChannelFetcher.new.search_channels(query)
    end
  end
end

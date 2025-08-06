# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :channel_lookup, Types::ChannelLookupType, null: true do
      description "Find a channel by ID"
      argument :id, ID, required: true, description: "ID of the channel lookup"
    end

    field :all_channel_lookups, [Types::ChannelLookupType], null: false, description: "Fetch all channel lookups stored in the database"

    
    field :search_channels, [Types::ChannelLookupType], null: false do
      description "Search for YouTube channels by keyword or name"
      argument :query, String, required: true
    end

    def channel_lookup(id:)
      ChannelLookup.find_by(id: id)
    end

    def all_channel_lookups
      ChannelLookup.all
    end

    def search_channels(query:)
      fetcher = YoutubeFetcher.new
      fetcher.search_channels(query)
    end
  end
end

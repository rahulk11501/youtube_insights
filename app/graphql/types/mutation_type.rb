# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end

    field :create_channel_lookup, Types::ChannelLookupType, null: false do
      description "Create a new channel lookup"
      argument :channel_id, String, required: true, description: "YouTube channel ID"
      argument :channel_name, String, required: false, description: "Name of the YouTube channel"
    end
    def create_channel_lookup(channel_id:, channel_name: nil)
      fetcher = YoutubeFetcher.new
      begin
        # Fetch channel data from YouTube API
        channel_data = fetcher.fetch_channel(channel_id)
      rescue StandardError => e
        Rails.logger.error("Error fetching channel data: #{e.message}")
      end
      return unprocessable_entity if channel_data.nil?

      channel_lookup = ChannelLookup.find_or_initialize_by(channel_id: channel_data[:channel_id])
      channel_lookup.assign_attributes(channel_data)
      if channel_lookup.save
        channel_lookup
      else
        unprocessable_entity(channel_lookup.errors)
      end
    end

  end
end


# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_channel_lookup, Types::ChannelLookupType, null: false do
      description "Create or update a YouTube channel lookup entry using channel ID, username, or URL/handle."

      argument :channel_id, String,
        required: false,
        description: "YouTube channel ID (e.g., UC_x5XG1OV2P6uZZ5FSM9Ttw)"

      argument :channel_name, String,
        required: false,
        description: "YouTube legacy username (e.g., GoogleDevelopers)"

      argument :handle_or_url, String,
        required: false,
        description: "YouTube channel URL or handle (e.g., https://youtube.com/@Google)"
    end

    def create_channel_lookup(channel_id: nil, channel_name: nil, handle_or_url: nil)
      fetcher = YoutubeFetcher.new

      begin
        channel_data = fetcher.fetch_channel(
          channel_id: channel_id,
          channel_name: channel_name,
          handle_or_url: handle_or_url
        )
      rescue StandardError => e
        Rails.logger.error("[GraphQL] YouTube Fetch Error: #{e.message}")
        raise GraphQL::ExecutionError, "Error fetching YouTube channel. Please check the inputs or try again later."
      end

      if channel_data.nil?
        raise GraphQL::ExecutionError, "No data found for the provided channel ID, name, or URL."
      end

      channel_lookup = ChannelLookup.find_or_initialize_by(channel_id: channel_data[:channel_id])
      channel_lookup.assign_attributes(channel_data)

      unless channel_lookup.save
        raise GraphQL::ExecutionError, channel_lookup.errors.full_messages.join(", ")
      end

      channel_lookup
    end
  end
end

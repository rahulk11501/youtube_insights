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

    # app/graphql/types/mutation_type.rb
    field :create_video_lookup, Types::VideoLookupType, null: false do
      description "Fetch and save a video by ID"
      argument :video_id, String, required: true
    end

    def create_channel_lookup(channel_id: nil, channel_name: nil, handle_or_url: nil)
      fetcher = Youtube::ChannelFetcher.new

      # Try to reuse cached data if it was fetched within the last 24 hours
      if channel_id.present?
        existing = ChannelLookup.find_by(channel_id: channel_id)
        if existing && existing.last_fetched_at.present? && existing.last_fetched_at > 24.hours.ago
          return existing
        end
      end

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
    
    def create_video_lookup(video_id: nil)
      video = VideoLookup.find_by(video_id: video_id)

      if video&.last_fetched_at.present? && video.last_fetched_at > 6.hours.ago
        return video
      end

      data = Youtube::VideoFetcher.new.fetch_video(video_id)

      raise GraphQL::ExecutionError, "Video not found or API error" if data.nil?

      video ||= VideoLookup.new(video_id: data[:video_id])
      video.assign_attributes(data)
      video.save!
      video
    end
  end
end

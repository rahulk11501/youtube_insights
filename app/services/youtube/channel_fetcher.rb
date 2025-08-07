# frozen_string_literal: true

module Youtube
  class ChannelFetcher
    def search_channels(query)
      # Replace this with actual API integration
      # For now, return a stubbed response or delegated logic
      YoutubeFetcher.new.search_channels(query)
    end

    def fetch_channel(channel_id: nil, channel_name: nil, handle_or_url: nil)
      YoutubeFetcher.new.fetch_channel(
        channel_id: channel_id,
        channel_name: channel_name,
        handle_or_url: handle_or_url
      )
    end
  end
end

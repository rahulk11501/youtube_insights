# app/services/youtube_fetcher.rb
class YoutubeFetcher
  include HTTParty
  base_uri 'https://www.googleapis.com/youtube/v3'

  def initialize(api_key = ENV['YOUTUBE_API_KEY'])
    @api_key = api_key
  end

  def fetch_channel(channel_id = nil, channel_name = nil)
    query_params = {
      part: 'snippet,statistics',
      key: @api_key
    }

    if channel_id
      query_params[:id] = channel_id
    elsif channel_name
      # Resolve channel_name to channel_id using YouTube search API
      resolved_id = resolve_channel_id_from_name(channel_name)
      return nil unless resolved_id
      query_params[:id] = resolved_id
    else
      raise ArgumentError, "You must provide either a channel_id or channel_name"
    end

    response = self.class.get('/channels', query: query_params)
    puts "response: #{response.inspect}" if Rails.env.development?

    return nil unless response.success?
    item = response.parsed_response['items']&.first
    return nil unless item

    {
      channel_id: item['id'],
      title: item['snippet']['title'],
      description: item['snippet']['description'],
      thumbnail_url: item['snippet']['thumbnails']['default']['url'],
      subscriber_count: item['statistics']['subscriberCount'],
      video_count: item['statistics']['videoCount'],
      view_count: item['statistics']['viewCount'],
      last_fetched_at: Time.current
    }
  end

  private

  def resolve_channel_id_from_name(channel_name)
    search_response = self.class.get('/search', query: {
      part: 'snippet',
      q: channel_name,
      type: 'channel',
      key: @api_key,
      maxResults: 1
    })

    return nil unless search_response.success?
    search_response.parsed_response['items']&.first&.dig('snippet', 'channelId')
  end
end

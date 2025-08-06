# app/services/youtube_fetcher.rb
class YoutubeFetcher
  include HTTParty
  base_uri 'https://www.googleapis.com/youtube/v3'

  def initialize(api_key = ENV['YOUTUBE_API_KEY'])
    @api_key = api_key
  end

  def fetch_channel(channel_id: nil, channel_name: nil, handle_or_url: nil)
    resolved_id = channel_id || resolve_channel_id(channel_name, handle_or_url)

    raise ArgumentError, "Unable to resolve a valid YouTube channel ID" unless resolved_id

    query_params = {
      part: 'snippet,statistics',
      id: resolved_id,
      key: @api_key
    }

    response = self.class.get('/channels', query: query_params)
    log_response(response)

    return nil unless response.success? && response.parsed_response['items'].present?

    item = response.parsed_response['items'].first
    format_channel_response(item)
  end

  def search_channels(query, max_results = 5)
    response = self.class.get('/search', query: {
      part: 'snippet',
      q: query,
      type: 'channel',
      maxResults: max_results,
      key: @api_key
    })

    log_response(response)
    return [] unless response.success?

    response.parsed_response['items'].map do |item|
      {
        channel_id: item.dig('snippet', 'channelId'),
        title: item.dig('snippet', 'title'),
        description: item.dig('snippet', 'description'),
        thumbnail_url: item.dig('snippet', 'thumbnails', 'default', 'url')
      }
    end
  end

  private

  def resolve_channel_id(channel_name, handle_or_url)
    return nil unless channel_name || handle_or_url

    query = channel_name || extract_handle_from_url(handle_or_url)
    return nil if query.blank?

    response = self.class.get('/search', query: {
      part: 'snippet',
      q: query,
      type: 'channel',
      maxResults: 1,
      key: @api_key
    })

    log_response(response)

    response.parsed_response.dig('items', 0, 'snippet', 'channelId')
  rescue => e
    Rails.logger.error("[YouTubeFetcher] resolve_channel_id error: #{e.message}")
    nil
  end

  def extract_handle_from_url(url)
    return nil if url.blank?

    uri = URI.parse(url)
    path = uri.path

    if path =~ %r{/@([\w\-]+)}
      Regexp.last_match(1)
    elsif path =~ %r{/c/([\w\-]+)}
      Regexp.last_match(1)
    elsif path =~ %r{/user/([\w\-]+)}
      Regexp.last_match(1)
    else
      nil
    end
  rescue URI::InvalidURIError
    nil
  end

  def format_channel_response(item)
    {
      channel_id: item['id'],
      title: item.dig('snippet', 'title'),
      description: item.dig('snippet', 'description'),
      thumbnail_url: item.dig('snippet', 'thumbnails', 'default', 'url'),
      subscriber_count: item.dig('statistics', 'subscriberCount'),
      video_count: item.dig('statistics', 'videoCount'),
      view_count: item.dig('statistics', 'viewCount'),
      last_fetched_at: Time.current
    }
  end

  def log_response(response)
    return unless Rails.env.development?

    puts "[YouTube API] #{response.code} - #{response.parsed_response.inspect}"
  end
end

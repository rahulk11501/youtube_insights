# app/services/youtube_fetcher.rb
class YoutubeFetcher
  include HTTParty
  base_uri 'https://www.googleapis.com/youtube/v3'

  def initialize(api_key = ENV['YOUTUBE_API_KEY'])
    @api_key = api_key
  end

  def fetch_channel(channel_id)
    response = self.class.get('/channels', query: {
      part: 'snippet,statistics',
      id: channel_id,
      key: @api_key
    })

    return nil unless response.success?

    item = response.parsed_response['items'].first
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
end

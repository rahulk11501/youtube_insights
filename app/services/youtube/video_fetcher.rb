# frozen_string_literal: true

module Youtube
    class VideoFetcher
        include HTTParty
        base_uri 'https://www.googleapis.com/youtube/v3'

    def initialize(api_key = ENV['YOUTUBE_API_KEY'])
        @api_key = api_key
    end

    def fetch_video(video_id)
        response = self.class.get('/videos', query: {
        part: 'snippet,statistics',
        id: video_id,
        key: @api_key
        })

        log_response(response)
        return nil unless response.success?

        item = response.parsed_response['items']&.first
        return nil unless item

        {
            video_id: item['id'],
            title: item['snippet']['title'],
            description: item['snippet']['description'],
            thumbnail_url: item['snippet']['thumbnails']['high']['url'],
            published_at: item['snippet']['publishedAt'],
            channel_id: item['snippet']['channelId'],
            channel_title: item['snippet']['channelTitle'],
            view_count: item.dig('statistics', 'viewCount')&.to_i,
            like_count: item.dig('statistics', 'likeCount')&.to_i,
            comment_count: item.dig('statistics', 'commentCount')&.to_i,
            last_fetched_at: Time.current
        }
    end

    def search_videos(query)
        response = self.class.get('/search', query: {
            part: 'snippet',
            q: query,
            type: 'video',
            maxResults: 10,
            key: @api_key
        })

        log_response(response)
        return [] unless response.success?

        response.parsed_response['items'].map do |item|
        {
            video_id: item.dig('id', 'videoId'),
            title: item.dig('snippet', 'title'),
            thumbnail_url: item.dig('snippet', 'thumbnails', 'high', 'url'),
            published_at: item.dig('snippet', 'publishedAt'),
            channel_title: item.dig('snippet', 'channelTitle')
        }
        end
    end

    private

    def log_response(response)
        return unless Rails.env.development?

        puts "[YouTube API] #{response.code} - #{response.parsed_response.inspect}"
    end
    end
end

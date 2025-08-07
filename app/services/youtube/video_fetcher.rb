# frozen_string_literal: true

module Youtube
  class VideoFetcher
    def search_videos(query)
      YoutubeFetcher.new.search_videos(query)
    end

    def fetch_video(video_id)
      YoutubeFetcher.new.fetch_video(video_id)
    end
  end
end

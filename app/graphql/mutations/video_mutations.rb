# frozen_string_literal: true

module Mutations
  module VideoMutations
    extend ActiveSupport::Concern

    included do
      field :create_video_lookup, Types::VideoLookupType, null: false do
        description "Fetch and save a video by ID"
        argument :video_id, String, required: true
      end
    end

    def create_video_lookup(video_id:)
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

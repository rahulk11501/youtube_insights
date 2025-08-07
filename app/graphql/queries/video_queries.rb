# app/graphql/types/queries/video_queries.rb
# frozen_string_literal: true

module Queries
  module VideoQueries
    extend ActiveSupport::Concern

    included do
      field :search_videos, [Types::VideoLookupType], null: false do
        description "Search for videos by keyword (does not persist)"
        argument :query, String, required: true
      end
    end

    def search_videos(query:)
      Youtube::VideoFetcher.new.search_videos(query)
    end
  end
end

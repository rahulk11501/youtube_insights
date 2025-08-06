class VideoLookup < ApplicationRecord
    validates :video_id, presence: true, uniqueness: true
end

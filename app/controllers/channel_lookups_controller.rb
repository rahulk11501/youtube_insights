# app/controllers/channel_lookups_controller.rb
class ChannelLookupsController < ApplicationController
  before_action :set_channel_lookup, only: %i[show]

  # POST /channel_lookups
  def create
    fetcher = YoutubeFetcher.new
    channel_data = fetcher.fetch_channel(params[:channel_id])

    if channel_data
      @channel_lookup = ChannelLookup.find_or_initialize_by(channel_id: channel_data[:channel_id])
      @channel_lookup.assign_attributes(channel_data)

      if @channel_lookup.save
        render json: @channel_lookup, status: :created
      else
        render json: @channel_lookup.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid channel ID or API limit reached' }, status: :bad_request
    end
  end

  # GET /channel_lookups/:id
  def show
    render json: @channel_lookup
  end

  private

  def set_channel_lookup
    @channel_lookup = ChannelLookup.find(params[:id])
  end
end

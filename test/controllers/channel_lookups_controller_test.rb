require "test_helper"

class ChannelLookupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel_lookup = channel_lookups(:one)
  end

  test "should get index" do
    get channel_lookups_url, as: :json
    assert_response :success
  end

  test "should create channel_lookup" do
    assert_difference("ChannelLookup.count") do
      post channel_lookups_url, params: { channel_lookup: { channel_id: @channel_lookup.channel_id, description: @channel_lookup.description, input: @channel_lookup.input, last_fetched_at: @channel_lookup.last_fetched_at, subscriber_count: @channel_lookup.subscriber_count, thumbnail_url: @channel_lookup.thumbnail_url, title: @channel_lookup.title, video_count: @channel_lookup.video_count, view_count: @channel_lookup.view_count } }, as: :json
    end

    assert_response :created
  end

  test "should show channel_lookup" do
    get channel_lookup_url(@channel_lookup), as: :json
    assert_response :success
  end

  test "should update channel_lookup" do
    patch channel_lookup_url(@channel_lookup), params: { channel_lookup: { channel_id: @channel_lookup.channel_id, description: @channel_lookup.description, input: @channel_lookup.input, last_fetched_at: @channel_lookup.last_fetched_at, subscriber_count: @channel_lookup.subscriber_count, thumbnail_url: @channel_lookup.thumbnail_url, title: @channel_lookup.title, video_count: @channel_lookup.video_count, view_count: @channel_lookup.view_count } }, as: :json
    assert_response :success
  end

  test "should destroy channel_lookup" do
    assert_difference("ChannelLookup.count", -1) do
      delete channel_lookup_url(@channel_lookup), as: :json
    end

    assert_response :no_content
  end
end

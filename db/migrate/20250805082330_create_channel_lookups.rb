class CreateChannelLookups < ActiveRecord::Migration[8.0]
  def change
    create_table :channel_lookups do |t|
      t.string :input
      t.string :channel_id
      t.string :title
      t.text :description
      t.string :thumbnail_url
      t.integer :subscriber_count
      t.integer :video_count
      t.integer :view_count
      t.datetime :last_fetched_at

      t.timestamps
    end
  end
end

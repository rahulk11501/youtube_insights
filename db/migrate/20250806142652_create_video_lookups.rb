class CreateVideoLookups < ActiveRecord::Migration[8.0]
  def change
    create_table :video_lookups do |t|
      t.string :video_id
      t.string :title
      t.text :description
      t.string :thumbnail_url
      t.datetime :published_at
      t.string :channel_id
      t.string :channel_title
      t.integer :view_count
      t.integer :like_count
      t.integer :comment_count
      t.datetime :last_fetched_at

      t.timestamps
    end
    add_index :video_lookups, :video_id
  end
end

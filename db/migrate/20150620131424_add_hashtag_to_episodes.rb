class AddHashtagToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :hashtag, :string
  end
end

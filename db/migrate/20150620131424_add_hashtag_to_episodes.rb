class AddHashtagToEpisodes < ActiveRecord::Migration[4.2]
  def change
    add_column :episodes, :hashtag, :string
  end
end

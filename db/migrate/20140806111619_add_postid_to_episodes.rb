class AddPostidToEpisodes < ActiveRecord::Migration[4.2]
  def change
    add_column :episodes, :postid, :int
  end
end

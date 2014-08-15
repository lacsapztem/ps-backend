class AddPostidToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :postid, :int
  end
end

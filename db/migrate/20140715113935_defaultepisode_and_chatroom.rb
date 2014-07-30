class DefaultepisodeAndChatroom < ActiveRecord::Migration
  def change
    add_column :episodes, :default ,  :boolean
    add_column :episodes, :chatroom ,  :text
  end
end

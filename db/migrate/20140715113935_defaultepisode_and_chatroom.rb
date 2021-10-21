class DefaultepisodeAndChatroom < ActiveRecord::Migration[4.2]
  def change
    add_column :episodes, :default ,  :boolean
    add_column :episodes, :chatroom ,  :text
  end
end

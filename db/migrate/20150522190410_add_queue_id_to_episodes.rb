class AddQueueIdToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :queue, :string
  end
end

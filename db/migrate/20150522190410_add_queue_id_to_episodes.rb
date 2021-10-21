class AddQueueIdToEpisodes < ActiveRecord::Migration[4.2]
  def change
    add_column :episodes, :queue, :string
  end
end

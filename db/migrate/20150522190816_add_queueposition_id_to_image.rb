class AddQueuepositionIdToImage < ActiveRecord::Migration[4.2]
  def change
    add_column :images, :queueposition, :int
  end
end

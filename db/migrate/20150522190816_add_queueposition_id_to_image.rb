class AddQueuepositionIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :queueposition, :int
  end
end

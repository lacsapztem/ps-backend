class AddQueuedToImages < ActiveRecord::Migration[4.2]
  def change
    add_column :images, :queued, :boolean
  end
end

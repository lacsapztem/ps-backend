class AddQueuedToImages < ActiveRecord::Migration
  def change
    add_column :images, :queued, :boolean
  end
end

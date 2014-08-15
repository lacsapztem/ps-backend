class RemoveImageFromImage < ActiveRecord::Migration
  def change
    remove_column :images, :image, :blob
  end
end

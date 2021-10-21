class RemoveImageFromImage < ActiveRecord::Migration[4.2]
  def change
    remove_column :images, :image, :blob
  end
end

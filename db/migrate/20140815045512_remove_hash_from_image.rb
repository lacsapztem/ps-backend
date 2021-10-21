class RemoveHashFromImage < ActiveRecord::Migration[4.2]
  def change
    remove_column :images, :hash, :blob
  end
end

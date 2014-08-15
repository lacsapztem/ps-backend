class RemoveHashFromImage < ActiveRecord::Migration
  def change
    remove_column :images, :hash, :blob
  end
end

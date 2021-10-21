class AddHashToImage < ActiveRecord::Migration[4.2]
  def change
    add_column :images, :hash, :string
  end
end

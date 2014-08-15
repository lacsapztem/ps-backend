class AddHashToImage < ActiveRecord::Migration
  def change
    add_column :images, :hash, :string
  end
end

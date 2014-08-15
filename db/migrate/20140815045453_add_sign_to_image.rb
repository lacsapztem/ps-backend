class AddSignToImage < ActiveRecord::Migration
  def change
    add_column :images, :sign, :string
  end
end

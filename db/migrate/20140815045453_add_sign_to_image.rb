class AddSignToImage < ActiveRecord::Migration[4.2]
  def change
    add_column :images, :sign, :string
  end
end

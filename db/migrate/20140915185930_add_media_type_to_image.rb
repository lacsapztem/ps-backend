class AddMediaTypeToImage < ActiveRecord::Migration[4.2]
  def change
    add_column :images, :media_type, :string, :default => 'img'
  end
end

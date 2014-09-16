class AddMediaTypeToImage < ActiveRecord::Migration
  def change
    add_column :images, :media_type, :string, :default => 'img'
  end
end

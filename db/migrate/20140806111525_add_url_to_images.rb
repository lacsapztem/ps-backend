class AddUrlToImages < ActiveRecord::Migration[4.2]
  def change
    add_column :images, :url, :string
  end
end

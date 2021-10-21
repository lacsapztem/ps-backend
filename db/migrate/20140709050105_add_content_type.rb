class AddContentType < ActiveRecord::Migration[4.2]
  def change
    add_column :images,:content_type,  :string
  end
end

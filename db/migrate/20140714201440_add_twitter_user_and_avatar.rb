class AddTwitterUserAndAvatar < ActiveRecord::Migration[4.2]
  def change
    add_column :images, :user ,  :string
    add_column :images, :avatar ,  :string
  end
end

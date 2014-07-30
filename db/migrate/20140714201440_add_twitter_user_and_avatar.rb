class AddTwitterUserAndAvatar < ActiveRecord::Migration
  def change
    add_column :images, :user ,  :string
    add_column :images, :avatar ,  :string
  end
end

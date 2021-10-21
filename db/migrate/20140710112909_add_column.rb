class AddColumn < ActiveRecord::Migration[4.2]
  def change
    add_column :images, :episode_id ,  :integer
  end
end

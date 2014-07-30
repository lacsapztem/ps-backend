class AddColumn < ActiveRecord::Migration
  def change
    add_column :images, :episode_id ,  :integer
  end
end

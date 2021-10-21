class CreateEpisodes < ActiveRecord::Migration[4.2]
  def change
    create_table :episodes do |t|
      t.string :title
      t.string :number

      t.timestamps
    end
  end
end

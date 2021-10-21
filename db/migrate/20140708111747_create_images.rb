class CreateImages < ActiveRecord::Migration[4.2]
  def change
    create_table :images do |t|
      t.string :name
      t.string :msg
      t.string :author
      t.binary :image

      t.timestamps
    end
  end
end

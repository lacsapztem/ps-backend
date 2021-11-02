class ChangeDataTypeForMsg < ActiveRecord::Migration[6.1]
  def change
    change_column(:images, :msg, :text)
  end
end

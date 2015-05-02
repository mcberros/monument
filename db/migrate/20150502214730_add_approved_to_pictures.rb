class AddApprovedToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :approved, :boolean, null: false, default: false
  end
end

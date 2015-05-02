class RemoveApprovedFromMonuments < ActiveRecord::Migration
  def change
  	remove_column :monuments, :approved, :boolean, null: false, default: false
  end
end

class CreateCategory < ActiveRecord::Migration
  def change
    create_table :categories do |t|
    	t.timestamps
    	t.string :name
    	t.integer :user_id
    end
  end
end

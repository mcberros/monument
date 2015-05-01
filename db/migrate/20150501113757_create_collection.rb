class CreateCollection < ActiveRecord::Migration
  def change
    create_table :monument_collections do |t|
    	t.timestamps
    	t.string :name, null: false
    	t.integer :user_id, null: false
    end
  end
end

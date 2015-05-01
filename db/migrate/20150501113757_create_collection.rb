class CreateCollection < ActiveRecord::Migration
  def change
    create_table :collections do |t|
    	t.timestamps
    	t.string :name
    	t.integer :user_id
    end
  end
end

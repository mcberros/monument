class CreateMonument < ActiveRecord::Migration
  def change
    create_table :monuments do |t|
    	t.timestamps
    	t.string :name
    	t.integer :collection_id
    	t.integer :category_id
    	t.boolean :public
    	t.boolean :approved
    end
  end
end

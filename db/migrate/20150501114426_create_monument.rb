class CreateMonument < ActiveRecord::Migration
  def change
    create_table :monuments do |t|
    	t.timestamps
    	t.string :name, null: false
        t.text :description
    	t.integer :monument_collection_id, null: false
    	t.integer :category_id
    	t.boolean :public, null: false, default: false
    	t.boolean :approved, null: false, default: false
    end
  end
end

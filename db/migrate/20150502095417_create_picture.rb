class CreatePicture < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
    	t.timestamps
    	t.string   :name, null: false
      t.text     :description
      t.datetime :date
    	t.integer  :monument_id, null: false
    end
  end
end

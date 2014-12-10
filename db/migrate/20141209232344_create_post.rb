class CreatePost < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :message, null: false
      t.integer :rsvp_id, null: false

      t.timestamps
    end
  end
end

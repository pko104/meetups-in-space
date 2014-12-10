class CreateRsvp < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.integer :user_id, null: false
      t.integer :meetup_id, null: false
      t.integer :message_id
    end
  end
end

class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :inviter_id
      t.string :recipient_name
      t.string :recipient_email
      t.text :message
      t.timestamps
    end
  end
end

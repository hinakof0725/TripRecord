class CreateCollaborations < ActiveRecord::Migration[7.2]
  def change
    create_table :collaborations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tweet, null: false, foreign_key: true

      t.timestamps
    end
    add_index :collaborations,
              [:user_id, :tweet_id],
              unique: true
  end
end

class CreateTweets < ActiveRecord::Migration[7.2]
  def change
    create_table :tweets do |t|
      t.string :title
      t.date :s_date
      t.date :f_date
      t.text :about

      t.timestamps
    end
  end
end

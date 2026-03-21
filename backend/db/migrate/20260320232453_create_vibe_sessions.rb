class CreateVibeSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :vibe_sessions do |t|
      t.string :mood_input

      t.timestamps
    end
  end
end

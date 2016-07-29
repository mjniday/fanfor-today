class CreateMatchweeks < ActiveRecord::Migration[5.0]
  def change
    create_table :matchweeks do |t|
      t.integer :week
      t.integer :status

      t.timestamps
    end
  end
end

class AddDateTimeToFixtures < ActiveRecord::Migration[5.0]
  def change
    add_column :fixtures, :date, :datetime
  end
end

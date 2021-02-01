class CreateDrivers < ActiveRecord::Migration[5.2]
  def change
    create_table :drivers do |t|
      t.string :full_name
      t.string :mobile_number, index: true
      t.float :rating, default: 5
      t.boolean :is_active, default: true, index: true
      t.timestamps
    end
  end
end

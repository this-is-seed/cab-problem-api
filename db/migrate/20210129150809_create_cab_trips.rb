class CreateCabTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :cab_trips do |t|
      t.references :customer
      t.references :driver
      t.integer :ride_number, index: true
      t.float :distance_travelled
      t.boolean :is_cancelled_before_start, default: false, index: true
      t.boolean :is_cancelled_after_start, default: false, index: true
      t.boolean :is_completed, default: false, index: true
      t.float :rating
      t.datetime :start_time
      t.datetime :end_time
      t.integer :waiting_time
      t.float :rate_per_km
      t.float :surge_amount
      t.string :status
      t.float :total_fair
      t.timestamps
    end
  end
end

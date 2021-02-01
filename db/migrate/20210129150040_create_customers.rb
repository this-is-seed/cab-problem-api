class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :full_name
      t.string :mobile_number, index: true
      t.references :customer_plan
      t.timestamps
    end
  end
end

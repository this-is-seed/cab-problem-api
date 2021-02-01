class CreateCustomerPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :customer_plans do |t|
      t.string :name
      t.string :code, index: true
      t.float :rating_required
      t.timestamps
    end
  end
end

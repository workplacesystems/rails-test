class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.date :date
      t.time :time
      t.string :code
      t.float :value
      t.string :password_hash

      t.timestamps
    end
  end
end

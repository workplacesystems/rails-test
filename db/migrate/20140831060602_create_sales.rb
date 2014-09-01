class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.datetime :date
      t.string :code
      t.decimal :value, :precision => 8, :scale => 2
      t.timestamps
    end
  end
end

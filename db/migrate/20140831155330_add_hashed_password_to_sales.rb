class AddHashedPasswordToSales < ActiveRecord::Migration
  def change
    add_column :sales, :hashed_password, :string
    add_index :sales, [:hashed_password], :unique => false
  end
end

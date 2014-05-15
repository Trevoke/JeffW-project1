class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :num_shares
      t.references :stock
      t.references :portfolio

      t.timestamps
    end
  end
end

class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.string :trade_date
      t.string :symbol
      t.float :close
      t.references :stock

      t.timestamps
    end
  end
end

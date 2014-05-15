class CreateInvestors < ActiveRecord::Migration
  def change
    create_table :investors do |t|
      t.string :username
      t.string :actualname

      t.timestamps
    end
  end
end

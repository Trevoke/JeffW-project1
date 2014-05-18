class AddLastupdateToStock < ActiveRecord::Migration
  def change
    add_column :stocks, :last_update, :string
  end
end

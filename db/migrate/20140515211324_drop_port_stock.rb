class DropPortStock < ActiveRecord::Migration
  def change
    drop_table :portfolios_stocks
  end
end

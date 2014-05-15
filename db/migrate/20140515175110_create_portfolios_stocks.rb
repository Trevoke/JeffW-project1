class CreatePortfoliosStocks < ActiveRecord::Migration
  def change
    create_table :portfolios_stocks do |t|
      t.references :stock
      t.references :portfolio
    end
  end
end

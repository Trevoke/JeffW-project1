class AddPwordDigestToInvestors < ActiveRecord::Migration
  def change
    add_column :investors, :password_digest, :string
  end
end

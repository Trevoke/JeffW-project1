class Investor < ActiveRecord::Base
  has_secure_password
  has_many :portfolios
  has_many :stocks, through: :portfolios
  has_many :shares, through: :portfolios
  validates_uniqueness_of :username


  def self.authorize(investor_id)
     if investor_id != current_investor.id
        return false
     else
        return true
     end
  end


end

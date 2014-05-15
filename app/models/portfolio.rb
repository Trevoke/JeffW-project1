class Portfolio < ActiveRecord::Base
  belongs_to :investor
  has_and_belongs_to_many :stocks
end


class WelcomeController < ApplicationController

  before_action:current_investor
  #before_action:populate_days

  def index
  end

end

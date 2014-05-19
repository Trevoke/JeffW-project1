require 'spec_helper'

describe Investor do

  it 'has secure password' do
    investor = Investor.create(username: "TestInvestor", password: "happy", password_confirmation: "happy")
    actual =  investor.authenticate("happy").username
    expected = "TestInvestor"
    expect(actual).to eq(expected)
  end
end


